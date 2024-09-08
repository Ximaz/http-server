/*
** EPITECH PROJECT, 2024
** HTTP Server
** File description:
** parse_http_method.c
*/

#include <string.h>
#include "http_parser.h"

static const char *METHODS[HTTP_METHOD_LIMIT] = {
    "GET", "HEAD", "POST", "PUT", "PATCH", "DELETE",
    "CONNECT", "OPTIONS", "TRACE"
};

http_method_t parse_http_method(const char *method, uint64_t length)
{
    int i = 0;

    for (; i < HTTP_METHOD_LIMIT; ++i)
        if (0 == strncmp(METHODS[i], method, length))
            return i;
    return HTTP_METHOD_LIMIT;
}
