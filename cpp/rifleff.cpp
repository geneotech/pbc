#include <iostream>
#include <string>
#include <fstream>

int main(int argc, const char** argv) {
 auto s = std::string(argv[1]);
 if ( s.front() == '"' ) {
    s.erase( 0, 1 ); // erase the first character
    s.erase( s.size() - 1 ); // erase the last character
}

std::string t("file://");
if (s.compare(0, t.length(), t) == 0)
{
s.erase(s.begin(), s.begin() + t.length());
}

const auto cmd = "rifle " + s;
    system(cmd.c_str());
}