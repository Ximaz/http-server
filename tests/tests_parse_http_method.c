/*
** EPITECH PROJECT, 2024
** HTTP Server
** File description:
** tests_parse_http_method.c
*/

#include <criterion/criterion.h>
#include "http_parser.h"

Test(http_parser, parse_http_method)
{
    cr_assert(parse_http_method("GET", 3) == GET);
    cr_assert(parse_http_method("HEAD", 4) == HEAD);
    cr_assert(parse_http_method("POST", 4) == POST);
    cr_assert(parse_http_method("PUT", 3) == PUT);
    cr_assert(parse_http_method("PATCH", 5) == PATCH);
    cr_assert(parse_http_method("DELETE", 6) == DELETE);
    cr_assert(parse_http_method("CONNECT", 7) == CONNECT);
    cr_assert(parse_http_method("OPTIONS", 7) == OPTIONS);
    cr_assert(parse_http_method("TRACE", 5) == TRACE);
    cr_assert(parse_http_method("??", 2) == HTTP_METHOD_LIMIT);
}
