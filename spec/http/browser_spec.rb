# Copyright, 2016, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'http/accept/media_types'
require 'http/accept/content_type'

RSpec.shared_examples "wildcard media range" do |env|
	let(:wildcard_media_ranges) {[HTTP::Accept::MediaTypes::WILDCARD_MEDIA_RANGE]}
	
	it "should match any content type" do
		expect(HTTP::Accept::MediaTypes.browser_preferred_media_types(env)).to be == wildcard_media_ranges
	end
end

RSpec.describe HTTP::Accept::MediaTypes do
	include_examples "wildcard media range", {'HTTP_ACCEPT' => '   */*   '}
	include_examples "wildcard media range", {'HTTP_ACCEPT' => '*/*'}
	
	# http://stackoverflow.com/questions/12130910/how-to-interpret-empty-http-accept-header
	include_examples "wildcard media range", {'HTTP_ACCEPT' => '   '}
	include_examples "wildcard media range", {'HTTP_ACCEPT' => ''}
	
	let(:text_plain_media_range) {HTTP::Accept::MediaTypes::MediaRange.new("text/plain", {})}
	
	it "should parse accept header" do
		media_types = HTTP::Accept::MediaTypes.browser_preferred_media_types('HTTP_ACCEPT' => text_plain_media_range.to_s)
		
		expect(media_types[0]).to be === text_plain_media_range
	end
end

RSpec.shared_context "server content types" do
	let(:json_content_type) {HTTP::Accept::ContentType.new('application/json')}
	let(:html_content_type) {HTTP::Accept::ContentType.new('text/html')}
	let(:wildcard_media_range) {HTTP::Accept::MediaTypes::MediaRange.new('*/*')}
	
	let(:map) {HTTP::Accept::MediaTypes::Map.new}
	let(:media_types) {HTTP::Accept::MediaTypes.parse(accept_header)}
end

RSpec.shared_examples "web browser" do
	include_context "server content types"
	
	it "should match text/html" do
		map << html_content_type
		map << json_content_type
		
		object, media_range = map.for(media_types)
		
		expect(object).to be == html_content_type
	end
end

RSpec.describe "Firefox Accept: headers" do
	let(:accept_header) {"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"}
	it_behaves_like "web browser"
end

RSpec.describe "WebKit Accept: headers" do
	let(:accept_header) {"application/xml,application/xhtml+xml,text/html;q=0.9, text/plain;q=0.8,image/png,*/*;q=0.5"}
	it_behaves_like "web browser"
end

RSpec.describe "Safari 5 Accept: headers" do
	let(:accept_header) {"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"}
	it_behaves_like "web browser"
end

RSpec.describe "Internet Explorer 8 Accept: headers" do
	# http://stackoverflow.com/questions/1670329/ie-accept-headers-changing-why
	let(:accept_header) {"image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/x-shockwave-flash, application/msword, */*"}
	it_behaves_like "web browser"
end

RSpec.describe "Opera Accept: headers" do
	let(:accept_header) {"text/html, application/xml;q=0.9, application/xhtml+xml, image/png, image/webp, image/jpeg, image/gif, image/x-xbitmap, */*;q=0.1"}
	it_behaves_like "web browser"
end

RSpec.shared_examples "json api" do
	include_context "server content types"
	
	it "should match application/json" do
		map << json_content_type
		
		object, media_range = map.for(media_types)
		
		expect(object).to be == json_content_type
	end
end

RSpec.describe "XMLHttpRequest Accept: headers" do
	let(:accept_header) {"application/json"}
	it_behaves_like "json api"
end