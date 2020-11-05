/* C:B**************************************************************************
This software is Copyright 2014-2017 Bright Plaza Inc. <drivetrust@drivetrust.com>

    This file is part of sedutil.

    sedutil is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    sedutil is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with sedutil.  If not, see <http://www.gnu.org/licenses/>.

* C:E********************************************************************** */

#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>

#include "GetNetPassPhrase.h"

#ifdef PBA_NETWORKING_BUILD

std::shared_ptr<SecureString> GetNetPassPhrase()
{
    int sockfd;
    char buffer[MAXLINE];
    char const *hello = "GIVEME_SEDUTIL_PASSWORD";
    struct sockaddr_in servaddr;

    // Creating socket file descriptor
    if ((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0)
    {
        perror("socket creation failed");
        exit(EXIT_FAILURE);
    }
    int broadcast_enable = 1;
    if (setsockopt(sockfd, SOL_SOCKET, SO_BROADCAST, &broadcast_enable, sizeof(broadcast_enable)) < 0)
    {
        perror("Error");
        std::shared_ptr<SecureString> password = std::allocate_shared<SecureString>(SecureAllocator<SecureString>(), "");
        return password;
    }

    struct timeval tv;
    tv.tv_sec = 3;
    tv.tv_usec = 0;
    if (setsockopt(sockfd, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv)) < 0)
    {
        perror("Error");
        std::shared_ptr<SecureString> password = std::allocate_shared<SecureString>(SecureAllocator<SecureString>(), "");
        return password;
    }

    memset(&servaddr, 0, sizeof(servaddr));

    // Filling server information
    servaddr.sin_family = AF_INET;
    servaddr.sin_port = htons(PORT);
    servaddr.sin_addr.s_addr = INADDR_BROADCAST;

    socklen_t len;
    int n;

    sendto(sockfd, (const char *)hello, strlen(hello),
           MSG_CONFIRM, (const struct sockaddr *)&servaddr,
           sizeof(servaddr));
    printf("Request sent.\n");

    n = recvfrom(sockfd, (char *)buffer, MAXLINE,
                 MSG_WAITALL, (struct sockaddr *)&servaddr,
                 &len);
    if (n < 0) {
        perror("Error receiving response");
        std::shared_ptr<SecureString> password = std::allocate_shared<SecureString>(SecureAllocator<SecureString>(), "");
        return password;
    }
    buffer[n] = '\0';
    printf("Received : %s\n", buffer);

    close(sockfd);

    std::shared_ptr<SecureString> password = std::allocate_shared<SecureString>(SecureAllocator<SecureString>(), buffer);
    return password;
}

#endif
