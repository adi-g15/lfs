#include <bits/stdc++.h>

using std::cout, std::string;
namespace fs = std::filesystem;

string get_name(const string& url) {
	return url.substr( url.find_last_of('/')+1 );
}

void clean_file(string fname) {
	string content, line;
	auto file = std::ifstream(fname);

	while(getline(file,line)){ if(!line.empty() && line.back() == '\r') {line.back() = '\n';} else {line.push_back('\n');}	content.append(line);	}

	file.close();

	auto fout = std::ofstream(fname);
	fout << content;
	fout.close();
}

int main () {
	auto urls = std::ifstream("urls.txt");

	std::string url;

	clean_file("urls.txt");

	std::set<std::string> downloaded;
	std::vector<std::string> to_download;

	for (auto& e: fs::directory_iterator(string(std::getenv("LFS")) + "/sources")) {
		downloaded.insert(e.path().filename());
	}

	while(getline(urls,url)) {
		auto name = get_name(url);

		if(downloaded.find(name) == downloaded.end()) {
			to_download.push_back(url);
		}
	}

	auto fout = std::ofstream("to_download.txt");

	for(auto& url: to_download) {
		fout << url << '\n';
	}
}

