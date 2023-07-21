// Cross-platform directory iterator
// Original version by Steve McNeill
// Changes and enhancements by a740g (24-June-2023)

#include <cstdint>
#include <cstdio>
#include <cstring>
#include <dirent.h>
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

int8_t __open_dir(const char *path)
{

  if (p_dir)
    return QB_FALSE; // return false if a directory is already open

  p_dir = opendir(path);
  if (!p_dir)
    return QB_FALSE;

  return QB_TRUE;
}

const char *read_dir(int *flags, int *file_size)
{
  static char dir_name[4096]; // 4k static buffer

  dir_name[0] = 0; // set to empty string

  auto next_entry = readdir(p_dir);

  if (!next_entry)
    return dir_name; // return an empty string to indicate we have nothing

  struct stat entry_info;
  stat(next_entry->d_name, &entry_info);

  *flags = S_ISDIR(entry_info.st_mode) ? IS_DIR_FLAG : IS_FILE_FLAG;
  *file_size = entry_info.st_size;

  strncpy(dir_name, next_entry->d_name, sizeof(dir_name));
  dir_name[sizeof(dir_name)] = 0; // overflow protection

  return dir_name; // QB64-PE does the right thing with this
}

void close_dir()
{
  closedir(p_dir);
  p_dir = nullptr; // set this to NULL so that subsequent __open_dir() works correctly
}
