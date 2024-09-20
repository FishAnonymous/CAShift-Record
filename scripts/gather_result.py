import os
import shutil

# src folder
cve_id = "CVE-2021-30465"
src_dir = f"output"

# dest folder
if not os.path.exists(cve_id):
    os.makedirs(cve_id)
else:
    # throw error and terminate
    print(f"result dir {cve_id} already exists")
    exit(1)

# counter
file_count = 1

# for each folder
for dir_name in os.listdir(src_dir):
    filenames = os.listdir(os.path.join(src_dir, dir_name))
    for file_name in sorted(filenames):
        if file_name != f"{len(filenames)}.scap":
            source_file = os.path.join(src_dir, dir_name, file_name)
            new_file_name = f'{file_count}.scap'
            target_file = os.path.join(cve_id, new_file_name)
            shutil.copy(source_file, target_file)
            # print(f"copy {file_name}.scap to {file_count}.scap")
            file_count += 1
        
        if file_count > 100:
            print("Enough")
            exit(0)

print("Finish")