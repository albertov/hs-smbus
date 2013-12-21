#include <errno.h>
#include <stdio.h>
#include <linux/i2c-dev.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <fcntl.h>
#include <unistd.h>

#include "HsSMBus.h"

int system_smbus_open(int adapter_nr)
{
    char filename[20];
    snprintf(filename, 19, "/dev/i2c-%d", adapter_nr); 
    return open(filename, O_RDWR);
}

int system_smbus_close(int fd)
{
    return close(fd);
}

int system_smbus_set_address(int fd, int addr)
{
    return ioctl(fd, I2C_SLAVE, addr);
}


int system_smbus_write(int fd, char *buf, ssize_t count)
{
    return write(fd, buf, count);
}

int system_smbus_read(int fd, char *buf, ssize_t count)
{
    return read(fd, buf, count);
}

int system_smbus_read_byte(int fd)
{
    return i2c_smbus_read_byte(fd);
}

int system_smbus_write_byte(int fd, char value)
{
    return i2c_smbus_write_byte(fd, value);
}

int system_smbus_read_byte_data(int fd, char command)
{
    return i2c_smbus_read_byte_data(fd, command);
}

int system_smbus_write_byte_data(int fd, char command, char value)
{
    return i2c_smbus_write_byte_data(fd, command, value);
}

/* TODO
  __s32 i2c_smbus_write_quick(int file, __u8 value);
  __s32 i2c_smbus_read_word_data(int file, __u8 command);
  __s32 i2c_smbus_write_word_data(int file, __u8 command, __u16 value);
  __s32 i2c_smbus_process_call(int file, __u8 command, __u16 value);
  __s32 i2c_smbus_read_block_data(int file, __u8 command, __u8 *values);
  __s32 i2c_smbus_write_block_data(int file, __u8 command, __u8 length, 
                                   __u8 *values)
*/
