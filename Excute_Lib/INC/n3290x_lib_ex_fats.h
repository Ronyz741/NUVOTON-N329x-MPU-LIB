#ifndef __N3290x_LIB_EX_FATS_H
#define __N3290x_LIB_EX_FATS_H

#ifdef __cplusplus
extern "C" {
#endif

#include "wblib.h"
#include "type_s.h"

//typedef enum {
//    O_RDONLY = 0x0001,    	/* Open for read only*/
//    O_WRONLY = 0x0002,      /* Open for write only*/
//    O_RDWR   = 0x0003,      /* Read/write access allowed.*/
//    O_APPEND = 0x0004,      /* Seek to eof on each write*/
//    O_CREATE = 0x0008,      /* Create the file if it does not exist.*/
//    O_TRUNC  = 0x0010,      /* Truncate the file if it already exists*/
//    O_EXCL   = 0x0020,      /* Fail if creating and already exists */
//    O_DIR    = 0x0080,      /* Open a directory file */
//    O_EXCLUSIVE = 0x0200,		/* Open a file with exclusive lock */
//    O_NODIRCHK	 = 0x0400,		/* no dir/file check */
//    O_FSEEK      = 0x1000,		/* Open with cluster chain cache to enhance file seeking performance */
//    O_IOC_VER2	 = 0x2000,		
//    O_INTERNAL	 = 0x8000
//}FILE_RULE;

typedef struct _fs_fun {
    /*
    * @param file_ascii_name 待打开的文件的ASCII文件名
    * @param file_rule 打开文件的权限
    * @return 文件的标号，>= 0 时打开正常
    * @exmple file1 = FAT_File_Open("C:\\test1.txt", O_RDONLY);
    */
    int (*file_open)(char *file_ascii_name, u32 file_rule);
    /*
    * @param file_num 文件的标号
    * @param *read_ptrbuff 读取的buff
    * @param want_read_num 将要读出的字节数
    * @param real_read_num 实际读出的字节数
    * @return 文件的标号，>= 0 时读取正常
    * @exmple sta = FAT_File_Read(1, buff, 20, &num);
    */
    int (*file_read)(int file_num,
                        u8 *read_ptrbuff,
                        u32 want_read_num,
                        u32 *real_read_num);
    /*
    * @param file_num 文件的标号
    * @param *read_ptrbuff 写入的buff
    * @param want_read_num 将要写入的字节数
    * @param real_read_num 实际写入的字节数
    * @return 文件的标号，>= 0 时写入正常
    * @exmple sta = FAT_File_Write(1, buff, 20, &num);
    */
    int (*file_write)(int file_num,
                        u8 *write_ptrbuff, 
                        u32 want_write_num,
                        u32 *real_write_num);
    /*
    * @param file_num 文件的标号
    * @return 文件的标号，>= 0 时文件关闭正常
    * @exmple sta = FAT_File_Close(1);
    */
    int (*file_close)(int file_num);
    /*
    * 必须先打开文件系统再打开SD外设才能正确的使用文件系统
    * @return 0 打开正常，otherwise 错误
    */
    int (*filesystem_sdopen_init)(void);
    /*
    * @param fileOldAsciiName 需要重命名的文件夹或者文件名，需要指明文件路径
    * @param fileNewAsciiName 重命名文件夹或者文件名为该名称，需要指明文件路径
    * @param DirOrFile TRUE ：重命名文件夹 FALUS ：重命名文件
    * @return 状态  0 文件重命名正常
    * @exmple sta = FAT_File_Rename("C:\\test1.txt", "C:\\test2.txt", FALUS);
    */
    int (*file_rename)(u8 *fileOldAsciiName, 
                            u8 *fileNewAsciiName,
                            u8 DirOrFile);
    /*
    * @param file_num 需要读取的文件
    * @return 文件大小
    */
    int (*file_getsize)(int file_num);
    /*
    * @param file_num 设定位置的文件
    * @param seek_offest 偏移量
    * @param seek_pos 指针位置 
    *      SEEK_SET file offset 0 + <nOffset>
    *      SEEK_CUR file current position + <nOffset>
    *      SEEK_END end of file position+ <nOffset>
    * @return 文件大小
    */
   int (*file_seek)(int file_num, long long seek_offest, short seek_pos);
}fs_fun_typedef;

extern fs_fun_typedef fs_fun;

#ifdef __cplusplus
}
#endif

#endif
