##
## EPITECH PROJECT, 2024
## HTTP Server
## File description:
## Makefile
##

CC	:=	gcc
NAME	:=	http_server
TESTS_NAME	:=	unit_tests
OS	:=	$(shell uname -s)

# Sources compilation flags
CPPFLAGS	:=	-Iinclude/
CFLAGS	:=	-Wall -Wextra -Werror -pedantic -ansi -fPIE 		 \
			-fno-delete-null-pointer-checks -fno-strict-overflow \
			-fno-strict-aliasing -ftrivial-auto-var-init=zero    \
			-Wformat -Wimplicit-fallthrough 					 \
			-U_FORTIFY_SOURCE -D_GLIBCXX_ASSERTIONS 			 \
			-fstack-protector-strong

ifeq ($(PLATFORM),x86_64)
	CFLAGS	:=	$(CFLAGS) -fcf-protection=full -Wl,-z,nodlopen	\
				-Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now 		\
				-fstack-clash-protection -fstrict-flex-arrays=3 -Wtrampolines
endif

ifeq ($(OS),Darwin)
	CFLAGS	+=	-mbranch-protection=standard
endif

# Tests compilation flags
TESTS_CFLAGS	:=	-g -Wall -Wextra -Werror --coverage -DCRITERION_TESTS
TESTS_CPPFLAGS	:=	-Iinclude/
TESTS_LDFLAGS	:=	-lcriterion

ifeq ($(OS),Darwin)
	TESTS_CPPFLAGS	+=	-I/opt/homebrew/include
	TESTS_LDFLAGS	:=	-L/opt/homebrew/lib -lcriterion
endif

# Valgrind flags
VALGRIND_FLAGS	:=	-s							\
					--leak-check=full			\
					--track-origins=yes			\
					--read-var-info=yes			\
					--trace-children=yes		\
					--show-leak-kinds=all		\
					--read-inline-info=yes		\
					--errors-for-leak-kinds=all

# Sources files
SRCS			:=	$(shell find src -type f -name '*.c')
OBJS			:=	$(SRCS:.c=.o)

# Tests files
TESTS_SRCS		:=	$(shell find tests -type f -name 'tests_*.c')
TESTS_OBJS		:=	$(TESTS_SRCS:.c=.o)

# Aliases
RM	:=	rm -rf

# Sources compilation

all:	$(OBJS)
	$(MAKE) $(NAME)

$(NAME):	$(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $@

# Tests compilation

tests/%.o:	tests/%.c
	$(CC) $(TESTS_CPPFLAGS) $(TESTS_CFLAGS) -o $@ -c $<

tests_run:	CFLAGS += -g --coverage -DCRITERION_TESTS
tests_run:	fclean	$(OBJS)	$(TESTS_OBJS)
	$(CC) $(TESTS_CFLAGS) $(OBJS) $(TESTS_OBJS) -o $(TESTS_NAME) \
		$(TESTS_LDFLAGS)
	CRITERION_NO_EARLY_EXIT=1 ./$(TESTS_NAME)
	gcovr -e tests .

# Valgrind rule

valgrind:	tests_run
	valgrind $(VALGRIND_FLAGS) ./$(TESTS_NAME)

# Utils rules

clean:
	@$(RM) $(OBJS)
	@$(RM) $(TESTS_OBJS)
	@$(RM) $(shell find . -type f -name '*.gcno')
	@$(RM) $(shell find . -type f -name '*.gcda')

fclean:	clean
	@$(RM) $(NAME)
	@$(RM) $(TESTS_NAME)

re:	fclean	all

.PHONY:	all	clean	fclean	re	valgrind
