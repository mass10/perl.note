#!/usr/bin/perl
# coding: utf-8
#
# UUID を生成するサンプルです。
#
use strict;
use Data::UUID;

sub _main {

	my $generator = Data::UUID->new;
	print($generator->create_str(), "\n");

	print('[www.mycompany.com] という文字列を使用して UUID を生成する。(毎回同じものが生成される)', "\n");
	print($generator->create_from_name_str(NameSpace_URL, 'www.mycompany.com'), "\n");
}

_main();
