BEGIN {
    FS = "\n";
}

/Schemes:/ {
    while (getline && $0 != "") {
        if ($0 ~ /Expecta/) continue;
        sub(/^ +/, "");
        print "'" $0 "'";
    }
}