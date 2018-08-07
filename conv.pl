#
# convert `RSP_REG := RSP_REG - tmp' to real rsp moving code
# convert `tmp := RSP_REG + offset' to real rsp reference code
#

while ( <> ) {
    chop;
    if ( /RSP_REG := RSP_REG - / ){
	s/RSP_REG/rsp/g;
	print $_,"\n";
	$_ = <>;
	chop;
	if (!/lea 	rax, 	RSP_REG/){
	    die "unexpected(1) :", $_,"\n";
	}
	$_ = <>;
	chop;
	if (!/mov 	rax, QWORD PTR \[rax\]/){
	    die "unexpected(2) :", $_,"\n";
	}
	$_ = <>;
	chop;
	if (!/mov 	ebx, DWORD PTR \[rbp/) {
	    die "unexpected(3) :", $_,"\n";
	}
	print $_, "\n";
	$_ = <>;
	chop;
	if (!/movsxd	rbx, ebx/) {
	    die "unexpected(4) :", $_,"\n";
	}
	print $_, "\n";
	$_ = <>;
	chop;
	if (!/sub 	rax, rbx/){
	    die "unexpected(5) :", $_,"\n";
	}
	s/rax/rsp/;
	print $_, "\n";
	$_ = <>;
	chop;
	if (!/lea 	rbx, RSP_REG/){
	    die "unexpected(6) :", $_,"\n";
	}
	$_ = <>;
	chop;
	if (!/mov 	QWORD PTR \[rbx\], rax/){
	    die "unexpected(7) :", $_,"\n";
	}
	next;
    }

    if (/:= RSP_REG \+ offset/ ){
	s/RSP_REG/rsp/;
	print $_,"\n";
	$_ = <>;
	chop;
	if (!/lea 	rax, 	RSP_REG/){
	    die "unexpected(8) :", $_,"\n";
	}
	$_ = <>;
	chop;
	if (!/mov 	rax, QWORD PTR \[rax\]/){
	    die "unexpected(9) :", $_,"\n";
	}
	$_ = <>;
	chop;
	if (!/mov 	ebx, DWORD PTR \[rbp/){
	    die "unexpected(10) :", $_,"\n";
	}
	print $_, "\n";
	$_ = <>;
	chop;
	if (!/movsxd	rbx, ebx/){
	    die "unexpected(11) :", $_,"\n";
	}
	print $_, "\n";
	$_ = <>;
	chop;
	if (!/add 	rax, rbx/){
	    die "unexpected(12) :", $_,"\n";
	}
	print "\t", "mov 	rax, rsp","\n";
	print $_, "\n";
	$_ = <>;
	chop;
	if (!/mov 	QWORD PTR \[rbp/){
	    die "unexpected(13) :", $_,"\n";
	}
	print $_, "\n";	
	next;
    }
    print $_, "\n";
}
