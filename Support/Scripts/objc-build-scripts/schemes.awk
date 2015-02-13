BEGIN {
    FS = "\n";
}

/Schemes:/ {
    while (getline && $0 != "") {
        if ($0 !~ /MagicalRecord/) continue;
        sub(/^ +/, "");
        print "'" $0 "'";
    }
}
