require 'rubygems'
require 'net/https'
require 'json'
require 'nokogiri'
require 'open-uri'


def get_html_document(document_url)
  uri = URI.parse(document_url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  request = Net::HTTP::Get.new(uri.request_uri)
  response = http.request(request)
  return response.body
end

settings = JSON.parse(File.read('settings.json'));
reports_dir = "reports/"
ccxml_url = settings['jenkins_ccxml_url']
builds = settings['cucumber_builds_for_statistics']
refresh_frequency = settings['report_fetch_interval_in_seconds']

while true

  puts "Trying to fetch latest build information"

  cc_xml_body = get_html_document(ccxml_url)

  if cc_xml_body.length <= 0
    puts "WARNING: Unable to get Jenkins latest build information file."
  else
    puts "Saving cc.xml for index.html to use"
    File.open('cc.xml', 'w') {|f| f.write(cc_xml_body) }

    cc_xml = Nokogiri::XML(cc_xml_body)
    
    builds.each do |build|
      begin
        build_name  = build[0]
        html_report_file = build[1]['jenkins_report_name']
        local_report_file = reports_dir + build[1]['local_report_file']

        newBuildNum = cc_xml.xpath("//Project[@name='"+build_name+"']").attr('lastBuildLabel')

        report_url = settings['jenkins_cucumber_report_base_url'] + build_name + "/" + newBuildNum + "/artifact/src/results/" + html_report_file;

        puts "Fetching HTML report of " + build_name + " from " + report_url
        build_report = Nokogiri::HTML(get_html_document(report_url))

        failed_test_divs = build_report.xpath("//script")

        local_report = open(local_report_file, "w")

        puts "Calculating failed tests"
        for i in 0..failed_test_divs.length
          if failed_test_divs[i].to_s.index("document.getElementById('totals')")

            div_contents = failed_test_divs[i].inner_html

            if div_contents.index("failed")
              #puts div_contents

              starting_position = div_contents.index("(", div_contents.rindex("=")+1)+1
              end_position = div_contents.index("failed")-1

              failed_tests_count = div_contents[starting_position..end_position].strip

              starting_position = div_contents.index("=")+3
              end_position = div_contents.index("scenarios")-1

              total_tests_count = div_contents[starting_position..end_position].strip

              local_report.write failed_tests_count.to_s + " of "+ total_tests_count.to_s

              puts "Failed tests : " + failed_tests_count.to_s + " of " +total_tests_count.to_s
            end
          end
        end
        puts "No failed tests for this build." if failed_tests_count.to_i == 0

        jira_count = 0

        all_tag_spans = build_report.xpath("//span[contains(@class, 'tag')] ")

        for i in 0..all_tag_spans.length
            if (all_tag_spans[i].to_s.downcase.index("jira"))
              jira_count=jira_count+1
            end
        end

        local_report.write " Jira: " + jira_count.to_s if jira_count > 0
        local_report.close

        puts "JIRA count : " + jira_count
      rescue
        "ERROR: Error while fetching information for " + build_name
      end
    end

  end

  sleep refresh_frequency
end
