<?php

/*
 *
 * CertDeliver Server
 * by Becod @ 2022.
 *
 */

$password = getenv('PASSWORD');
$encryptionMethod = "AES-256-CBC";
$iv = openssl_random_pseudo_bytes(openssl_cipher_iv_length($encryptionMethod));

function error401(){
	header("HTTP/1.0 401 Unauthorized");
	echo '{"code":401,"message":"Unauthorized"}';
	exit;
}

function error400(){
	header("HTTP/1.0 400 Bad Request");
	echo '{"code":400,"message":"Bad Request"}';
	exit;
}
function enc($key, $data, $iv, $encryptionMethod) {
	return openssl_encrypt($data, $encryptionMethod, $key, 0, $iv);
}

if(empty($_GET['domain'])){
	error400();
}elseif(empty($_GET['m'])){
	error400();
}elseif(empty($_GET['token'])){
	error401();
}else{
	$domain = $_GET["domain"];
	$random_number = $_GET["m"];
	$client_token = $_GET["token"];
}

if(md5($password.$domain.$random_number) == $client_token){
	$encpw = $password.$domain.$random_number;
	if(file_exists("/acme.sh/".$domain)){
		$rsa_fullchain = fopen("/acme.sh/".$domain."/fullchain.cer", "r");
		$rsa_full_chain = fread($rsa_fullchain,filesize("/acme.sh/".$domain."/fullchain.cer"));
		fclose($rsa_fullchain);

		$rsa_key = fopen("/acme.sh/".$domain."/".$domain.".key", "r");
		$rsa__key = fread($rsa_key,filesize("/acme.sh/".$domain."/".$domain.".key"));
		fclose($rsa_key);

		$rsa_full_chain_enc = enc($encpw, $rsa_full_chain, $iv, $encryptionMethod);
		$rsa_key_enc = enc($encpw, $rsa__key, $iv, $encryptionMethod);
	}

	if(file_exists("/acme.sh/".$domain."_ecc")){
		$ecc_fullchain = fopen("/acme.sh/".$domain."_ecc/fullchain.cer", "r");
		$ecc_full_chain = fread($ecc_fullchain,filesize("/acme.sh/".$domain."_ecc/fullchain.cer"));
		fclose($ecc_fullchain);

		$ecc_key = fopen("/acme.sh/".$domain."_ecc/".$domain.".key", "r");
		$ecc__key = fread($ecc_key,filesize("/acme.sh/".$domain."_ecc/".$domain.".key"));
		fclose($ecc_key);

		$ecc_full_chain_enc = enc($encpw, $ecc_full_chain, $iv, $encryptionMethod);
		$ecc_key_enc = enc($encpw, $ecc__key, $iv, $encryptionMethod);
	}
	
	echo json_encode(array(
		"rsa" => array(
			"fullchain" => $rsa_full_chain_enc,
			"key" => $rsa_key_enc,
		),
		"ecc" => array(
			"fullchain" => $ecc_full_chain_enc,
			"key" => $ecc_key_enc,
		),
		"iv" => bin2hex($iv)
	));
}else{
	error401();
}
?>