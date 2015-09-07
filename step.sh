#!/bin/bash

THIS_SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${THIS_SCRIPTDIR}/_utils.sh"
source "${THIS_SCRIPTDIR}/_formatted_output.sh"

# init / cleanup the formatted output
echo "" > "${formatted_output_file_path}"

write_section_start_to_formatted_output "# Info"
echo_string_to_formatted_output "* Pinging: \`${ping_url}\`"
if [ -z "${curl_params}" ]; then
	echo_string_to_formatted_output "* No Optional cURL parameters (empty)"
else
	echo_string_to_formatted_output "* Optional cURL parameters: \`${curl_params}\`"
fi

if [ -z "${ping_url}" ]; then
	write_section_to_formatted_output "# Error"
	write_section_start_to_formatted_output '* Required input `$ping_url` not provided!'
	exit 1
fi

# eval to split the combined params
eval curl -f ${ping_url} ${curl_params}
curl_res=$?

if [ ${curl_res} -eq 0 ]; then
	write_section_to_formatted_output "# Success"
else
	write_section_to_formatted_output "# Error"
	echo_string_to_formatted_output "* cURL ping returned an error (${curl_res})"
	echo_string_to_formatted_output "* see the logs for more details" false
fi

exit ${curl_res}