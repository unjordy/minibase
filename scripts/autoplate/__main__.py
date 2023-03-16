import sys
import shutil
from rectpack import newPacker
from configparser import ConfigParser
from pathlib import Path

def main() -> int:
    packer = newPacker()
    plateconfig = ConfigParser()
    autoplate_ini = ConfigParser()

    try:
        plateconfig.read('.plateconfig')
        plate_size_x = float(plateconfig['plate']['size_x'])
        plate_size_y = float(plateconfig['plate']['size_y'])
        spacing = float(plateconfig.get('plate', 'spacing', fallback=8))
    except KeyError:
        print("""autoplater: missing .plateconfig
        Please create a .plateconfig file in the root of your project with:
        [plate]
        size_x = <the x size (width) of your printer plate>
        size_y = <the y size (height) of your printer plate>

        # Optional:
        [objects]
        spacing = <how much room to leave around objects for rafts>
        """)
        return 1

    autoplate_ini.read('out/.autoplate.ini')
    print('autoplater: fitting {} objects with {}mm spacing into {}mmx{}mm plates'
          .format(len(autoplate_ini.sections()), spacing, plate_size_x, plate_size_y))

    packer.add_bin(plate_size_x, plate_size_y, count=float('inf'))

    for stl in autoplate_ini.sections():
        stl_data = autoplate_ini[stl]
        packer.add_rect(float(stl_data['size_x']) + spacing, float(stl_data['size_y']) + spacing, stl)

    packer.pack()
    if(Path('out/autoplater').exists()):
        shutil.rmtree('out/autoplater', ignore_errors=True);

    for (b, x, y, w, h, rid) in packer.rect_list():
        plate_path = Path('out/autoplater/plate{}'.format(b))
        stl_path = Path(rid).resolve(strict=True)
        out_name = Path('{}-{}'.format(stl_path.parents[0].name, stl_path.name))
        out_path = plate_path.joinpath(out_name)

        plate_path.mkdir(parents=True, exist_ok=True)
        out_path.unlink(missing_ok=True)
        out_path.symlink_to(stl_path)

    print ('autoplater: created {} {}mmx{}mm plates'
           .format(len(packer), plate_size_x, plate_size_y))

    return 0

if __name__ == '__main__':
    sys.exit(main())
