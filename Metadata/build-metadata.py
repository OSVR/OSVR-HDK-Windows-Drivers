import os
import shutil
from jinja2 import BaseLoader, TemplateNotFound

class MetadataTemplateLoader(BaseLoader):
    def __init__(self, input_dir):
        self.input_dir = input_dir
    def get_source(self, environment, template):
        path = os.path.join(self.input_dir, template)
        if not os.path.exists(path):
            raise TemplateNotFound(template)
        mtime = os.path.getmtime(path)
        with open(path, 'rb') as f:
            source = f.read().decode('utf-8')
        return source, path, lambda: mtime == os.path.getmtime(path)

def path_join(a, b):
    return os.path.join(a, b)

class CabinetFile:
    def __init__(self):
        from jinja2 import Template
        with open("ddf-templates/template.ddf", 'rb') as f:
            self.overall_template = Template(f.read().decode('utf-8'))

        with open("ddf-templates/dirtemplate", 'rb') as f:
            self.dir_template = Template(f.read().decode('utf-8'))
        self.dir_template.globals['path_join'] = path_join
        self.dirs = []

    def generate(self, input_dir, ddf_fn, out_dir, cabname):
        dirdata = [self.dir_template.render(root=root, dest_dir = os.path.relpath(root, input_dir), files=files)
            for root, dirs, files in os.walk(input_dir)]
        with open(ddf_fn, 'wb') as f:
            f.write(self.overall_template.render(dirs = dirdata, out_dir = out_dir, cabname = cabname).encode('utf-8'))
        from subprocess import call
        call(["makecab", "/f", ddf_fn])

class MetadataFile:
    def __init__(self, input_dir, output_dir):
        from uuid import uuid4
        self.experience_guid = str(uuid4())
        #self.default_locale = "en"
        self.input_dir = os.path.abspath(input_dir)
        self.output_dir = os.path.abspath(output_dir)

        import datetime
        self.timestamp = datetime.datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%S.%fZ")
        import jinja2
        self.env = jinja2.Environment(keep_trailing_newline = True, optimized = False, loader = MetadataTemplateLoader(self.input_dir))
        #self.env = jinja2.Environment(keep_trailing_newline = True, optimized = False, loader = jinja2.FileSystemLoader(self.input_dir))

        self.env.globals["experience_guid"] = self.experience_guid
        self.env.globals["last_modified"] = self.timestamp


    def generate(self):
        self.generate_output_directory()

        # format all files "in-place" into the new tree
        for root, dirs, files in os.walk(self.input_dir):
            reldir = os.path.relpath(root, self.input_dir)
            outdir = self.get_output_path(reldir)
            if not os.path.exists(outdir):
                os.makedirs(outdir)
            #print(reldir, root, files)
            self.process_dir(reldir, files)

        # Load the root XML file to find out the default locale
        self.read_package_info()

        # copy WindowsInformation/self.default_locale/* to WindowsInformation/
        # and similarly for DeviceInformation
        for subdir in self.locale_subdirs:
            self.copy_from_default_locale(subdir)

    def pack_cab_into(self, cab_dir):
        cab = CabinetFile()
        cab_input_dir = os.path.join(self.output_dir, self.experience_guid)
        ddf_file = os.path.join(self.output_dir, "devicemetadata.ddf")
        cab.generate(cab_input_dir, ddf_file, cab_dir, self.experience_guid + ".devicemetadata-ms")

    def read_package_info(self):
        # Find out the default locale
        import xml.etree.ElementTree as ET
        tree = ET.parse(self.get_input_path("PackageInfo.xml"))
        root = tree.getroot()
        ns = "{http://schemas.microsoft.com/windows/DeviceMetadata/PackageInfo/2007/11/}"
        self.default_locale = root.findall(".//" + ns + "Locale[@default='true']")[0].text
        self.locale_subdirs = []
        for id in ["http://schemas.microsoft.com/windows/DeviceMetadata/DeviceInfo/2007/11/", "http://schemas.microsoft.com/windows/DeviceMetadata/WindowsInfo/2007/11/"]:
            self.locale_subdirs.extend([x.text for x in root.findall(".//" + ns + "Metadata[@MetadataID='" + id + "']")])
        print(self.locale_subdirs)

    def copy_from_default_locale(self, subdir):
        default_locale_dir = self.get_output_path(os.path.join(subdir, self.default_locale))
        base_dir = self.get_output_path(subdir)
        for root, dirs, files in os.walk(default_locale_dir):
            for fn in files:
                full_source = os.path.join(root, fn)
                rel_to_locale = os.path.relpath(full_source, default_locale_dir)
                full_dest = os.path.join(base_dir, rel_to_locale)
                print("Copying default locale", subdir, rel_to_locale)
                shutil.copy(full_source, full_dest)

    def process_dir(self, reldir, files):
        for fn in files:
            self.process_file(reldir, fn)

    def process_file(self, reldir, fn):
        (stem, ext) = os.path.splitext(fn)
        if reldir == os.curdir:
            path = fn
        else:
            path = os.path.join(reldir, fn)
        print("Extension: ", ext)
        if ext == ".xml":
            self.format_file(path)
        else:
            self.copy_file(path)

    def format_file(self, path):
        print("Processing as template", path)
        template = self.env.get_template(path)
        outpath = self.get_output_path(path)
        with open(outpath, 'wb') as f:
            f.write(template.render().encode('utf-8'))

    def copy_file(self, path):
        print("Copying", path)
        shutil.copy(self.get_input_path(path), self.get_output_path(path))

    def get_output_path(self, path):
        return os.path.join(self.output_dir, self.experience_guid, path)

    def get_input_path(self, path):
        return os.path.join(self.input_dir, path)

    def get_input_relative(self, dir, file):
        return os.path.relpath(os.path.join(dir, file), self.input_dir)
    def generate_output_directory(self):
        os.makedirs(os.path.join(self.output_dir, self.experience_guid))

baseoutdir = os.path.abspath("Output")
def process_dir(dirname):
    staging_dir = os.path.join(baseoutdir, dirname)
    metadata = MetadataFile(dirname, os.path.join(baseoutdir, dirname))
    print("Metadata GUID: " + metadata.experience_guid)
    metadata.generate()
    metadata.pack_cab_into(staging_dir)

process_dir("HMDDisplay")
process_dir("HMDOnly")
process_dir("BeltBox")
process_dir("TrackingCamera")
