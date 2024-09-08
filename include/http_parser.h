/*
** EPITECH PROJECT, 2024
** HTTP Parser
** File description:
** http_parser.h
*/

/**
 * This HTTP parser aims to provide all functions to parse an HTTP/1.1 request,
 * as defined by the RFC 9112.
 *
 * According to the RFC 5322 Section 2, which provides a lexical analysis of an
 * Internel Message Form, the length limit of a line MUST be no more than 998
 * characters, and SHOULD NOT be more than 78 characters, both excluding CRLF.
 *
 * A header field-body MUST NOT include CRLF characters otherwise than in a
 * folding context, in which the character right after the CRLF must be a white
 * space. This is a workaround regarding the limit of 998/78 characters.
 *
 * A sender MUST NOT generate a "bare" CR (not followed by LF). If such thing
 * occurs, the message MUST BE either invalidated, or "CR" must be treated as
 * "CRLF" before forwarding the message.
 *
 * A sender must not send whitespace between the start-line and the first
 * header field. If such thing occurs, the message MUST either be invalidated,
 * or each whitespace between start-line and first header field MUST BE
 * consummed.
 */

/**
 * The request line format :
 *
 * METHOD <space> URI <space> HTTP/<HTTP_MAJOR>.<HTTP_MINOR>
 *
 * If the METHOD is not implemented by the server, it MUST return 501 code.
 * If the URI is longer than any uRI length expected, it MUST return 414 code.
 * It's recommended to support a request line of at minimum 8000 bytes length.
 *
 * No whitespace is allowed in the URI. If it happens, the server MUST NOT try
 * to deduce the correct path, but instead, either return a 400 code, or 301 by
 * redirecting the client to a safe location.
 */

/**
 * If a message doesn't contain the "Host" header field, the request MUST BE
 * invalidated, and the server MUST respond with a 400 code.
 */

/**
 * FORMS OF URI
 *
 * origin-form : /<path>?query
 * absolute-form : http://www.example.com/<path>?query
 * authority-form : www.example.com:80
 * asterisk-form (only for OPTIONS requests) : *
 */

#ifndef __HTTP_PARSER_H_

    #define __HTTP_PARSER_H_

/* HTTP/1.1 */
    #define HTTP_MAJOR 1
    #define HTTP_MINOR 1

    #include <stdint.h>

typedef enum e_http_method {
    GET,
    HEAD,
    POST,
    PUT,
    PATCH,
    DELETE,
    CONNECT,
    OPTIONS,
    TRACE,
    /* Used both to iterate and represent an invalid method. */
    HTTP_METHOD_LIMIT
} http_method_t;

typedef struct s_http_header {
    char *name; /* NULL-terminated. */
    char *value; /* NULL-terminated. */
} http_header_t;

typedef struct s_http_request {
    http_method_t method;
    char *request; /* request-target, NULL-terminated */
    http_header_t *headers; /* A NULL-terminated array (should be a hashmap) */
    char *body; /* NULL if no body, NOT NULL-terminated. */
    uint64_t body_length; /* 0 if no body. */
} http_request_t;

http_method_t parse_http_method(const char *method, uint64_t length);

#endif /* !__HTTP_PARSER_H_ */
