#ifndef HS_SMBUS_H
#define HS_SMBUS_H
#include <sys/types.h>

int system_smbus_open(int adapter_nr);
int system_smbus_close(int fd);
int system_smbus_set_address(int fd, int addr);
int system_smbus_write(int fd, char *buf, ssize_t len);
int system_smbus_read(int fd, char *buf, ssize_t len);
int system_smbus_read_byte(int fd);
int system_smbus_write_byte(int fd, char value);
int system_smbus_read_byte_data(int fd, char command);
int system_smbus_write_byte_data(int fd, char command, char value);

#endif // HS_SMBUS_H
