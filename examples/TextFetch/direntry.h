// Changes and enhancements by a740g (24-June-2023)

#include <stdio.h>
#include <dirent.h>
#include <stdint.h>
#include <sys/stat.h>
#include <unistd.h>

enum : int8_t
{
  QB_TRUE = -1,
  QB_FALSE
};

enum : int32_t
{
  IS_DIR_FLAG = 1,
  IS_FILE_FLAG
};

static DIR *p_dir = nullptr;

int8_t load_dir(const char *path)
{
  p_dir = opendir(path);
  if (!p_dir)
    return QB_FALSE;

  return QB_TRUE;
}

const char *get_next_entry(int *flags, int *file_size)
{
  auto next_entry = readdir(p_dir);

  if (!next_entry)
    return ""; // return an empty string to indicate we have nothing

  struct stat entry_info;
  stat(next_entry->d_name, &entry_info);

  *flags = S_ISDIR(entry_info.st_mode) ? IS_DIR_FLAG : IS_FILE_FLAG;
  *file_size = entry_info.st_size;

  return next_entry->d_name; // QB64-PE does the right thing with this
}

void close_dir()
{
  closedir(p_dir);
  p_dir = nullptr;
}
