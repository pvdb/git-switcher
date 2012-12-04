#
# Methadone/Aruba "extensions"/"customizations"
#

When /^I get the version of "([^"]*)"$/ do |script_name|
  @script_name = script_name
  step %(I run `#{script_name} --version`)
end

Then /^the output should include the version$/ do
  step %(the output should match /v\\d+\\.\\d+\\.\\d+/)
end

Then /^the output should include the app name$/ do
  step %(the output should match /#{Regexp.escape(@script_name)}/)
end

Then /^the output should include a copyright notice$/ do
  step %(the output should match /Copyright \\(c\\) [\\d]{4} [[\\w]+]+/)
end

