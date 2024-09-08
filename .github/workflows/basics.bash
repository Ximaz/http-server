#!/bin/bash -xe

# Temporary files

[[ $(find . -type f \( -name '*.o' -o -name '*.log' -o -name '.env' -o -name '*.so' -o -name '*.a' -o -name '*.gcno' -o -name '*.gcda' \)) == "" ]] || exit 1

# Checking for the artifacts before compilation

for a in $ARTIFACTS; do [ ! -f "${a}" ]; done

# Checking make on it's own

make && for a in $ARTIFACTS; do [ -f "${a}" ]; done

# Checking for make relink on it's own

[[ $(make) == "" ]] && exit 1

# Checking 'all' rule

make all && for a in $ARTIFACTS; do [ -f "${a}" ]; done

# Checking for 'all' make relink

[[ $(make all) == "" ]] && exit 1

# Checking 'clean' rule

make clean && echo $(find . -type d -name '.git' -prune -o \( -type f \( -name '*.o' -o -name '.env' -o -name '*.log' -o -name '*.gcno' -o -name '*.gcda' \) \) -print) && [[ $(find . -type d -name '.git' -prune -o \( -type f \( -name '*.o' -o -name '.env' -o -name '*.log' -o -name '*.gcno' -o -name '*.gcda' \) \) -print) == "" ]] || exit 1

# Checking 'fclean' rule

make
make fclean
for a in $ARTIFACTS; do [ ! -f "${a}" ]; done
[[ $(find . -type d -name '.git' -prune -o \( -type f \( -name '*.o' -o -name '*.log' -o -name '.env' -o -name '*.so' -o -name '*.a' -o -name '*.gcno' -o -name '*.gcda' \) \) -print) == "" ]] || exit 1

# Checking 're' rule

make re
for a in $ARTIFACTS ; do [ -f "${a}" ]; done

# Checking the artifacts rule

for a in $ARTIFACTS; do make "${a}" && [ -f "${a}" ]; done

# Checking for the artifacts make relink

for a in $ARTIFACTS; do
    if [[ $(make "${a}") == "" ]]; then exit 1; fi;
done

# Clean up

make fclean
