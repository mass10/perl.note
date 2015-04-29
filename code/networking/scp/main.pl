#!/usr/bin/env perl
# coding: utf-8
#
#
#
# Perl で SCP
#
# - パスワードなし認証の手続きを済ませておかなければならないことに注意。(authorized_keys)
# - 使えないことはないがインターフェイスがいまいちである。
#
#

use strict;
use POSIX;
use Net::SSH::Perl;
use Net::SCP;










###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
package out;

sub println {

	print(@_, "\n");
}













###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
package application;

sub new {

	my ($name, $host, $user) = @_;
	my $instance = {};
	my $session = Net::SCP->new( {
			'host' => $host,
			'user' => $user,
			'interactive' => 0 } );
	$instance->{'.session'} = $session;
	return bless($instance, $name);
}

sub _get_connection {

	my ($this) = @_;
	return $this->{'.session'};
}

sub send {

	my ($this, $left, $right) = @_;
	my $session = $this->_get_connection();
	$session->scp($left, $right);
	my $message = $session->{errstr};
	if(length($message)) {
		out::println('[ERROR] ', $message);
		return 0;
	}
	out::println('[INFO] sending ... [', $left, '] >>> [', $right, ']');
	return 1;
}

sub DESTROY {
	
	my ($this) = @_;
	if(defined($this->{'.session'})) {
		out::println('(closing...)');
		delete($this->{'.session'});
	}
}








###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
package main;


sub _main {

	my $host = '192.168.141.147';
	my $user = 'root';

	my $scp = new application($host, $user);
	if(!defined($scp)) {
		out::println('[ERROR] 失敗！ ', $!);
		return;
	}

	# - リモートのタイムスタンプはオリジナル(=ローカル)のものを維持する。
	# - リモートのパーミッションはオリジナル(=ローカル)のものを維持する。
	# - いちいちホストを指定しなければならない。

	# [SUCCESS] 存在しているディレクトリに転送する。
	$scp->send('main.pl', '192.168.141.147:/tmp/SCP-PATH/');

	# [SUCCESS] 新しいファイルを作成し、オリジナルのタイムスタンプを維持する。
	$scp->send('main.pl', '192.168.141.147:/tmp/SCP-PATH/xxxxxxxxxx');

	# [SUCCESS] ファイルを上書きし、オリジナルのタイムスタンプを維持する。
	$scp->send('main.pl', '192.168.141.147:/tmp/SCP-PATH/xxxxxxxxxx');
	$scp->send('main.pl', '192.168.141.147:/tmp/SCP-PATH/xxxxxxxxxx');
	$scp->send('main.pl', '192.168.141.147:/tmp/SCP-PATH/xxxxxxxxxx');
	$scp->send('main.pl', '192.168.141.147:/tmp/SCP-PATH/xxxxxxxxxx');

	# [ERROR] 存在しないディレクトリには転送できない。
	$scp->send('main.pl', '192.168.141.147:/tmp/SCP-PATH/xxxxxxxxxxxxxx/');
}

main::_main();
