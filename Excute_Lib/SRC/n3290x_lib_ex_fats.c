#include "n3290x_lib_ex_fats.h"
#include "wblib.h"
#include "nvtfat.h"
#include "stdio.h"
#include "string.h"
#include "w55fa93_sic.h"

static int FAT_File_Open(char *file_ascii_name, u32 file_rule);
static int FAT_File_Read(int file_num,
                            u8 *read_ptrbuff,
                            u32 want_read_num,
                            u32 *real_read_num);
static int FAT_File_Write(int file_num,
                            u8 *write_ptrbuff, 
                            u32 want_write_num,
                            u32 *real_write_num);
static int FAT_File_Close(int file_num);
static int FAT_FileSystem_SDOpen_Init(void);
static int FAT_File_Rename(u8 *fileOldAsciiName, 
                            u8 *fileNewAsciiName,
                            u8 DirOrFile);
static int FAT_File_GetSize(int file_num);
static int FAT_File_Seek(int file_num,
                            long long seek_offest,
                            short seek_pos);

fs_fun_typedef fs_fun = {
    .file_open  = FAT_File_Open,
    .file_read  = FAT_File_Read,
    .file_write = FAT_File_Write,
    .file_close = FAT_File_Close,
    .filesystem_sdopen_init = FAT_FileSystem_SDOpen_Init,
    .file_rename = FAT_File_Rename,
    .file_getsize = FAT_File_GetSize,
    .file_seek = FAT_File_Seek
};

/*
 * @param file_ascii_name 待打开的文件的ASCII文件名
 * @param file_rule 打开文件的权限
 * @return 文件的标号，>= 0 时打开正常
 * @exmple file1 = FAT_File_Open("C:\\test1.txt", O_RDONLY);
*/
static int FAT_File_Open(char *file_ascii_name, u32 file_rule)
{
    CHAR szNvtFullName[64], suNvtFullName[512];
    int FileHandle;

    /* change the attribute of file name : ascii to unicode*/
    strcpy(szNvtFullName, file_ascii_name);
    fsAsciiToUnicode(szNvtFullName, suNvtFullName, TRUE);
    FileHandle = fsOpenFile(suNvtFullName, NULL, file_rule);
	return FileHandle;
}

/*
 * @param file_num 文件的标号
 * @param *read_ptrbuff 读取的buff
 * @param want_read_num 将要读出的字节数
 * @param real_read_num 实际读出的字节数
 * @return 文件的标号，>= 0 时读取正常
 * @exmple sta = FAT_File_Read(1, buff, 20, &num);
*/
static int FAT_File_Read(int file_num,
                         u8 *read_ptrbuff,
                         u32 want_read_num,
                         u32 *real_read_num)
{
    int sta;
    sta = fsReadFile(file_num, read_ptrbuff, want_read_num, (INT*)real_read_num);
    return sta;
}

/*
 * @param file_num 文件的标号
 * @param *read_ptrbuff 写入的buff
 * @param want_read_num 将要写入的字节数
 * @param real_read_num 实际写入的字节数
 * @return 文件的标号，>= 0 时写入正常
 * @exmple sta = FAT_File_Write(1, buff, 20, &num);
*/
static int FAT_File_Write(int file_num,
                          u8 *write_ptrbuff, 
                          u32 want_write_num,
                          u32 *real_write_num)
{
    int sta;
    sta = fsWriteFile(file_num, write_ptrbuff, want_write_num, (INT*)real_write_num);
    return sta;
}

/*
 * @param file_num 文件的标号
 * @return 文件的标号，>= 0 时文件关闭正常
 * @exmple sta = FAT_File_Close(1);
*/
static int FAT_File_Close(int file_num)
{
    int sta;
    sta = fsCloseFile(file_num);
    return sta;
}

/*
 * 必须先打开文件系统再打开SD外设才能正确的使用文件系统
 * @return 0 打开正常，otherwise 错误
*/
static int FAT_FileSystem_SDOpen_Init()
{
    int sta;
    sta = fsInitFileSystem();
    sta |= sicSdOpen0();
    return sta;
}

/*
 * @param fileOldAsciiName 需要重命名的文件夹或者文件名，需要指明文件路径
 * @param fileNewAsciiName 重命名文件夹或者文件名为该名称，需要指明文件路径
 * @param DirOrFile TRUE ：重命名文件夹 FALUS ：重命名文件
 * @return 状态  0 文件重命名正常
 * @exmple sta = FAT_File_Rename("C:\\test1.txt", "C:\\test2.txt", FALUS);
*/
static int FAT_File_Rename(u8 *fileOldAsciiName, 
                            u8 *fileNewAsciiName,
                            u8 DirOrFile)
{
    int sta;
    u8 fileOldUnicodeName[512], fileNewUnicodeName[512];
    fsAsciiToUnicode(fileOldAsciiName, fileOldUnicodeName, TRUE);
    fsAsciiToUnicode(fileNewAsciiName, fileNewAsciiName, TRUE);
    sta = fsRenameFile((CHAR*)fileOldUnicodeName, NULL, (CHAR*)fileNewUnicodeName, NULL, DirOrFile);
    return sta;
}

/*
 * @param file_num 需要读取的文件
 * @return 文件大小
*/
static int FAT_File_GetSize(int file_num)
{
    int file_size;
    file_size = fsGetFileSize(file_num);
    return file_size;
}

/*
 * @param file_num 设定位置的文件
 * @param seek_offest 偏移量
 * @param seek_pos 指针位置 
 *      SEEK_SET file offset 0 + <nOffset>
 *      SEEK_CUR file current position + <nOffset>
 *      SEEK_END end of file position+ <nOffset>
 * @return 文件大小
*/
static int FAT_File_Seek(int file_num,
                            long long seek_offest,
                            short seek_pos)
{
    fsFileSeek(file_num, seek_offest, seek_pos);
}

