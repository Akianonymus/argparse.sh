#!/usr/bin/env sh
# shellcheck source=/dev/null

###################################################
# setup all the flags help, stuff to be executed for them and pre process
# todo: maybe post processing too
###################################################
_parser_setup_flags() {
    # add initial help text which will appear at start
    _parser_add_help "
The script can be used to download file/directory from google drive.

Usage: ${0##*/} [options.. ] <file_[url|id]> or <folder[url|id]>

Options:"

    ###################################################

    # not a flag exactly, but will be used to process any arguments which is not a flag
    _parser_setup_flag "input" 0
    _parser_setup_flag_help \
        "Drive urls or id to process."

    _parser_setup_flag_preprocess 4<< 'EOF'
unset TOTAL_INPUTS INPUT_ID
EOF

    _parser_setup_flag_process 4<< 'EOF'
# set ID_INPUT_NUM to the input, where num is rank of input
id_parse_arguments=""
_extract_id "${1}" id_parse_arguments 

if [ -n "${id_parse_arguments}" ]; then
    # this works well in place of arrays
    _set_value d "INPUT_ID_$((TOTAL_INPUTS += 1))" "${id_parse_arguments}"
fi
EOF

    ###################################################

    _parser_setup_flag "-D --debug" 0
    _parser_setup_flag_help \
        "Display script command trace."

    _parser_setup_flag_preprocess 4<< 'EOF'
unset DEBUG
EOF

    _parser_setup_flag_process 4<< 'EOF'
export DEBUG="true"
EOF

    ###################################################

    _parser_setup_flag "-h --help" 1 optional "flag name"
    _parser_setup_flag_help \
        "Print help for all flags and basic usage instructions.

To see help for a specific flag, --help flag_name ( with or without dashes )
    e.g: ${0##*/} --help aria"

    _parser_setup_flag_preprocess 4<< 'EOF'
###################################################
# 1st arg - can be flag name
# if 1st arg given, print specific flag help
# otherwise print full help
###################################################
_usage() {
    [ -n "${1}" ] && {
        for flag_usage in "${@}"; do
            help_usage_usage=""
            _flag_help "${flag_usage}" help_usage_usage

            if [ -z "${help_usage_usage}" ]; then
                printf "%s\n" "Error: No help found for ${flag_usage}"
            else
                printf "%s\n%s\n%s\n" "${__PARSER_BAR}" "${help_usage_usage}" "${__PARSER_BAR}"
            fi
        done
        exit 0
    }

    printf "%s\n" "${_PARSER_ALL_HELP}"
    exit 0
}
EOF

    _parser_setup_flag_process 4<< 'EOF'
_usage "${2}"
EOF

    ###################################################

    return 0
}
