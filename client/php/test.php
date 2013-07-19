<?php

function solve_captcha($host,$key,$bid,$file,$ca_file) {
  $url = $host."/captcha/Google?auth_token=$key&business_id=$bid";
  echo "\nfile: $file\n"; 
  echo "posting to: $url\n";
  $post_data['image'] = '@'.$file;
  echo "post_data: ".var_dump($post_data)."\n";
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, $url);
  curl_setopt($ch, CURLOPT_POSTFIELDS, $post_data);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($ch, CURLOPT_VERBOSE, 1);
  curl_setopt($ch, CURLOPT_CAINFO, $ca_file);
  $response = curl_exec($ch);
  echo "response: $response\n";
  if ($response == false) {
    return false;
  } else {
    echo $response;
    $results = json_decode($response, true);
    return $results['answer'];
  }
}

$host = 'https://citation.netversa.com';
$key = $argv[1];
$bid = $argv[2];
$file = $argv[3];
$ca_file = $argv[4];

echo "res: ".solve_captcha($host, $key, $bid, $file, $ca_file);

?>
