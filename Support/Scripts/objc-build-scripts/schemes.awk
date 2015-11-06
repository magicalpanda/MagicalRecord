BEGIN {
    FS = "\n";
}

/Schemes:/ {
    while (getline && $0 != "") {
        if ($0 ~ /Test|Expecta/) continue;

        sub(/^ +/, "");
        print "'" $0 "'";
    }
}
