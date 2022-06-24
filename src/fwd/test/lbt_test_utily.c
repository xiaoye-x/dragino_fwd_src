#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include "logger.h"
#include "uart.h"

/* --- PUBLIC DECLARATION ---------------------------------------- */
uint8_t LOG_INFO = 1;
uint8_t LOG_PKT = 1;
uint8_t LOG_WARNING = 1;
uint8_t LOG_ERROR = 1;
uint8_t LOG_REPORT = 1;
uint8_t LOG_JIT = 0;
uint8_t LOG_JIT_ERROR = 0;
uint8_t LOG_BEACON = 0;
uint8_t LOG_DEBUG = 1;
uint8_t LOG_TIMERSYNC = 0;
uint8_t LOG_MEM = 0;

int main(int argc, char* argv[])
{
    int fd, ret, i = 10, len;
    int baude = 9600;
    int timeout = 1000;
    int flow = 0;
    char buffer[32] = {'\0'};
    char msg[48] = {'\0'};

    printf("LBT test utility start...\r\n");

    if (argc < 3) { 
        printf("Need argument, tty_path and tty command\n");
        printf("Usage: %s tty_path command timeout flow baude\r\n", argv[0]);
        printf("       %s /dev/ttyUSB4 \"AT+GETCHANSTAT=923200000,-85,6\" 2000 0 9600\r\n", argv[0]);
        return -1;
    }

    if (argc > 3) {
       timeout = atoi(argv[3]);
    }

    if (argc > 4) {
       flow = atoi(argv[4]);
    }

    if (argc > 5) {
       baude = atoi(argv[5]);
    }

    printf("Timeout set to %d\n", timeout);
    printf("Flow set to %d\n", flow);
    printf("Baude set to %d\n", baude);

    if ((fd = uart_open(argv[1])) < 0) {
        printf("open %s is failed\n",  argv[1]);
    } else {
        printf("open %s is success, fd=%d\n", argv[1], fd);
        ret = uart_config(fd, baude, flow, 9, 9, 9); 
        printf("uart_config retval=%d\n", ret);
        len =  snprintf(msg, sizeof(msg), "%s\r\n", argv[2]);
        while (i--) {
            ret = uart_send(fd, msg, len);

            printf("\r\n");

            if (ret < 0)
                printf("write failed\n");
            else 
                printf("SEND ATCOM => (%s)\n", msg);

            memset(buffer, 0, sizeof(buffer));

            ret = uart_read(fd, buffer, sizeof(buffer), timeout); 

            if (ret > 0) {  
                //printf("read uart buffer: %s \n", buffer);
                if (buffer[0] == 'F')
                    printf("LBT_DETECT: CHANNEL is FREE\n");
                else
                    printf("LBT_DETECT: CHANNEL is BUSY\n");
            }

            
            printf("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n");
            printf("Wait 1 secends for next LBT　detect\n");
            printf("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n");
            printf("\r\n");
            sleep(1);
        }
    }
    uart_close(fd);
}
