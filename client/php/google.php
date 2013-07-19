<?php

error_reporting(E_ALL); ini_set('display_errors', '1');

#
# Copyright (C) 2013 Net Versa, LLC.
#
//========================================================
##
## Curl.php
##
//========================================================

echo "Are here!\n";

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

function phone_verify ($host,$key,$bid,$file,$ca_file) {
  $url = $host."/codes/Google.json?auth_token=$key&business_id=$bid";
  echo "\n$url\n";
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, $url);
  //curl_setopt($ch, CURLOPT_POSTFIELDS, $post_data);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($ch, CURLOPT_VERBOSE, 1);
  curl_setopt($ch, CURLOPT_CAINFO, $ca_file);
  $retries = 0;
  while ($retries < 25)
  {
    $response = curl_exec($ch);
    echo "response: $response\n";
    if ($response != false) {
      $results = json_decode($response, true);
      return $results['code'];
    }
    sleep(10);
    $retries++;

  }

}


#function are_we_authorized($host, $key) {
#  $url = $host."/users/sign_in?auth_token=".$key;
#  echo $url . "\n";
#  $tuCurl = curl_init(); 
#  curl_setopt($tuCurl, CURLOPT_URL, $url);
#  curl_setopt($tuCurl, CURLOPT_VERBOSE, 0); 
#  $res = curl_exec($tuCurl); 
#  $info = curl_getinfo($tuCurl);
#  echo "info: ".var_dump($info)."\n";
#  echo "info: ".$info['http_code']."\n";
#  if ($info['http_code'] != 302) {
#    echo "No access!\n";
#    exit;
#  }
#}

function save_account_info($host, $key, $bid, $email, $password, $secretA, $ca_file) {
  $url = $host."/accounts.json?auth_token=$key&business_id=$bid";
  $post_data['model']                  = 'Google';
  $post_data['account[email]']         = $email;
  $post_data['account[password]']      = $password;
  $post_data['account[secret_answer]'] = $secretA;
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, $url);
  curl_setopt($ch, CURLOPT_POSTFIELDS, $post_data);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($ch, CURLOPT_CAINFO, $ca_file);
  $response = curl_exec($ch);
  if ($response == false) {
    return false;
  } else {
    return $response;
  }
}

function RemoveJSEncode($str){
$str=str_replace('\u002f','/',$str);
$str=str_replace('\u003f','?',$str);
$str=str_replace('\u003d','=',$str);
$str=str_replace('\u0026','&',$str);
$str=str_replace('\u0025','%',$str);
return $str;	
}
function SpecialSleep($st, $en){
$rand = rand($st, $en);
usleep($rand);
flush();
}

function get_string($tofind, $toend, $searchstr){
    $str1= $tofind;          
	  $pos = strpos($searchstr, $str1);           
	  $pos = $pos+strlen($str1);                
    $tmp= substr($searchstr, $pos, strlen($searchstr));        
    $str1= $toend;                             
	  $pos = strpos($tmp, $str1);          
    $tmp= substr($tmp, 0, $pos);  	
	  return $tmp;
}
function get_laststring($tofind, $toend, $searchstr){
    $str1= $tofind;          
	  $pos = strrpos($searchstr, $str1);           
	  $pos = $pos+strlen($str1);                
    $tmp= substr($searchstr, $pos, strlen($searchstr));        
    $str1= $toend;                             
	  $pos = strpos($tmp, $str1);          
    $tmp= substr($tmp, 0, $pos);  	
	  return $tmp;
}
function randLetter($case){
if($case=='1'){
return strtoupper(chr(97 + mt_rand(0, 25)));
}else{
return chr(97 + mt_rand(0, 25));	
}
}

function GETcurl($burl, $referrer, $agent, $follow, $cookie_file_path, $useprxy, $proxy_ip, $proxy_port, $loginpassw, $timeout, $returnhead){

        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL,$burl);
        curl_setopt($ch, CURLOPT_USERAGENT, $agent);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, $follow);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
        if($useprxy==1){
				curl_setopt($ch, CURLOPT_PROXYPORT, $proxy_port);
				curl_setopt($ch, CURLOPT_PROXYTYPE, 'HTTP');
				curl_setopt($ch, CURLOPT_PROXY, $proxy_ip);
				curl_setopt($ch, CURLOPT_PROXYUSERPWD, $loginpassw);
			  }
				curl_setopt($ch, CURLOPT_COOKIEFILE, $cookie_file_path);
        curl_setopt($ch, CURLOPT_COOKIEJAR, $cookie_file_path);
        if($referrer!==''){curl_setopt($ch, CURLOPT_REFERER, $referrer);}
        curl_setopt($ch, CURLINFO_HEADER_OUT, true);      // Set Curl to output header sent
        curl_setopt($ch, CURLOPT_HEADER, TRUE);           // Grab Header Data - Basically we want cookie:
        curl_setopt($ch, CURLOPT_VERBOSE, TRUE);          // Debugging when set to 1
			  curl_setopt($ch, CURLOPT_CONNECTTIMEOUT,$timeout);
			  curl_setopt($ch, CURLOPT_TIMEOUT,$timeout);  
        $result = curl_exec ($ch);
        $headers = curl_getinfo($ch, CURLINFO_HEADER_OUT);
        if(curl_errno($ch)){
        //echo 'Curl error: '.$burl.'<br>'. curl_error($ch);
        return 'error';
        } 
        curl_close ($ch);	
        if($returnhead==1){
        return $headers.'<br>'.$result;		
        }else{
        return $result;	
        }
}

function GETcurl_Headers($burl, $referrer, $agent, $follow, $cookie_file_path, $useprxy, $proxy_ip, $proxy_port, $loginpassw, $timeout, $returnhead, $useheaders, $http_headers){

        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL,$burl);
        curl_setopt($ch, CURLOPT_USERAGENT, $agent);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, $follow);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
        if($useprxy==1){
				curl_setopt($ch, CURLOPT_PROXYPORT, $proxy_port);
				curl_setopt($ch, CURLOPT_PROXYTYPE, 'HTTP');
				curl_setopt($ch, CURLOPT_PROXY, $proxy_ip);
				curl_setopt($ch, CURLOPT_PROXYUSERPWD, $loginpassw);
			  }
				curl_setopt($ch, CURLOPT_COOKIEFILE, $cookie_file_path);
        curl_setopt($ch, CURLOPT_COOKIEJAR, $cookie_file_path);
        if($referrer!==''){curl_setopt($ch, CURLOPT_REFERER, $referrer);} 
        curl_setopt($ch, CURLINFO_HEADER_OUT, true);      // Set Curl to output header sent
        curl_setopt($ch, CURLOPT_HEADER, TRUE);           // Grab Header Data - Basically we want cookie:
        curl_setopt($ch, CURLOPT_VERBOSE, TRUE);          // Debugging when set to 1
			  curl_setopt($ch, CURLOPT_CONNECTTIMEOUT,$timeout);
			  curl_setopt($ch, CURLOPT_TIMEOUT,$timeout);  
			  
			  if($useheaders==1){
        curl_setopt($ch, CURLOPT_HTTPHEADER, $http_headers);
        }
			  
        $result = curl_exec ($ch);
        $headers = curl_getinfo($ch, CURLINFO_HEADER_OUT);
        if(curl_errno($ch)){
        //echo 'Curl error: '.$burl.'<br>'. curl_error($ch);
        return 'error';
        } 
        curl_close ($ch);	
        if($returnhead==1){
        return $headers.'<br>'.$result;		
        }else{
        return $result;	
        }
}

function POSTcurl($burl, $referrer, $agent, $postvar, $follow, $cookie_file_path, $useprxy, $proxy_ip, $proxy_port, $timeout, $returnhead,$useheaders,$http_headers){
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL,$burl);
        curl_setopt($ch, CURLOPT_USERAGENT, $agent);
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_POSTFIELDS,$postvar);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, $follow);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
        if($referrer!==''){curl_setopt($ch, CURLOPT_REFERER, $referrer);}
        if($useprxy==1){
				curl_setopt($ch, CURLOPT_PROXYPORT, $proxy_port);
				curl_setopt($ch, CURLOPT_PROXYTYPE, 'HTTP');
				curl_setopt($ch, CURLOPT_PROXY, $proxy_ip);
				//curl_setopt($ch, CURLOPT_PROXYUSERPWD, $loginpassw);
			  }
        curl_setopt($ch, CURLOPT_COOKIEFILE, $cookie_file_path);
        curl_setopt($ch, CURLOPT_COOKIEJAR, $cookie_file_path);
        curl_setopt($ch, CURLINFO_HEADER_OUT, true);      // Set Curl to output header sent
        curl_setopt($ch, CURLOPT_HEADER, TRUE);           // Grab Header Data - Basically we want cookie:
        curl_setopt($ch, CURLOPT_VERBOSE, TRUE);          // Debugging when set to 1  
			  curl_setopt($ch, CURLOPT_CONNECTTIMEOUT,$timeout);
        curl_setopt($ch, CURLOPT_ENCODING, "");			
			  
			  curl_setopt($ch, CURLOPT_TIMEOUT,$timeout);    
       // curl_setopt($ch, CURLOPT_ENCODING, "");
        
        // Headers
        if($useheaders==1){
        curl_setopt($ch, CURLOPT_HTTPHEADER, $http_headers);
        }
        
        $result = curl_exec ($ch);
        $headers = curl_getinfo($ch, CURLINFO_HEADER_OUT);
        //echo '<br>'.$headers.'<br>';
        if(curl_errno($ch)){
        //echo 'Curl error: '.$burl.'<br>'. curl_error($ch);
        return 'error';
        } 
        curl_close ($ch);
        if($returnhead==1){
        return $headers.'<br>'.$result;		
        }else{
        return $result;	
        }
}

//========================================================
##
## Script starts
##
//========================================================

echo "Starting creation!\n";

$fname = getenv('fname');
$lname = getenv('lname');
$recoverEmail = getenv('recover_email');
$enviroment = getenv('enviroment');
$bid = getenv('bid');
$key = getenv('key');
$useragent = getenv('useragent');
$ca_file = getenv('ca_file');
$phone = getenv('phone');

// setup directory
if ($enviroment != "test") {
	$savePath = getenv('USERPROFILE')."\\citation\\".$bid."\\google\\";
}
else {
	$savePath = "google";
}
if (!file_exists($savePath)) {
    	mkdir($savePath, 0777, true);
}
if (getenv("CITATION_HOST"))
{
  $zeeHost = getenv("CITATION_HOST");
}
else
{
  $zeeHost = "https://citation.netversa.com";
}


// For testing phone verify
//echo phone_verify($zeeHost,$key,$bid,$file_path,$ca_file);

//exit;

// Grab the citation host



#are_we_authorized($zeeHost, $key);

$refr = '';

//exit;
//=============================================
// Version 3 of Google Account Creation
// Resale strictly prohibited
//=============================================

//=============================================
// Allow script to not timeout
			ini_set('max_execution_time', 0);
			set_time_limit(0);
			ignore_user_abort(true);
//=============================================

//=============================================
// Grab Post Variables
			$uid=$bid;//"uid";//$_POST['i'];   			// Userid // set to $_GET for testing
			$reqid=$key;//""$_POST['r']; 			// Request id
			$gtype='1';         			//Gender Selector 1 for female
//=============================================

//=============================================
// Create Unique Cookie File

if ($enviroment == "test")
	{
		$cookie_file_path = dirname(__FILE__)."google_cookie.txt"; // /
		$fp = fopen($cookie_file_path,'wb');
		fclose($fp);
	}
else
	{
		$cookie_file_path = $savePath."google_cookie.txt"; // /
		$fp = fopen($cookie_file_path,'wb');
		fclose($fp);

	} 


//=============================================

//=============================================
// Grab Proxy Account From Database
			
/*			if (!mysql_connect($db_host, $db_user, $db_pwd))    die("Can't connect to database");
      if (!mysql_select_db($database))    die("Can't select database");
      $result = mysql_query("SELECT * FROM proxies where status='0' and uid='$uid' and gcnt < '1' and gflag='0' order by RAND() LIMIT 1");
      $vexist = mysql_num_rows($result);
      if($vexist > 0){        
      $row = mysql_fetch_array ($result);
      $tmpp=explode(":", $row['addy']);
      $proxy_ip=$tmpp[0];
      $proxy_port=$tmpp[1];
      $proxy=$row['addy'];
      $ipuser=$row['user'];
      $ippass=trim($row['pass']);
      $ippass=trim($ippass);
*/


	  //$proxy_ip = "184.154.79.45";

      
	if ($enviroment == "test") {
		$proxy_ip = getenv('proxy');
		$useprxy=1;
	} else {
		$proxy_ip = null;
		$useprxy=0;
	}
	$proxy_port = "80";
      //$useprxy=1;    //Turn proxy on/off
      $timeout='40'; //set timeout to 40 seconds
//      if($ipuser<>''){$loginpassw=$ipuser.':'.$ippass;}
 //     }else{
   // 	echo 'No Proxies';exit();
    //  }
//=============================================

//=============================================
// Delay to appear more natural
			SpecialSleep('500000','1000000');
//=============================================

//=============================================
// Grab Name Info From Db
		//	if (!mysql_connect($db_host, $db_user, $db_pwd))    die("Can't connect to database");
		//	if (!mysql_select_db($database))    die("Can't select database");
		//	$fnid=rand(1,999999); // Quicker here than in db
		//	$lnid=rand(1,999999); //
		//	$result = mysql_query("SELECT `first`, `last`, `female_fname`.`zip` FROM `female_fname`, `female_lname` where `female_fname`.`id`='$fnid' and `female_lname`.`id`='$lnid'");
		//	$row = mysql_fetch_array ($result);
		//	$rid=$row['id'];
		//	$zipcode=$row['zip'];
			$fname=str_replace(" ","",$fname); //
			$fname=strtoupper(substr($fname, 0, 1)).strtolower(substr($fname, 1, strlen($fname))); // Make sure name is Capitalized
			$lname=str_replace(" ","",$lname); //
			$lname=strtoupper(substr($lname, 0, 1)).strtolower(substr($lname, 1, strlen($lname))); // Make sure name is Capitalized
			$full_name=$fname.' '.$lname;
//--------------------------------------

//--------------------------------------
      //Create a username
			$rt=rand(0,1); //Random Selector
			if($rt==1){$email=$fname.$lname;}else{$email=$lname.$fname;} //Make username
			
			//Create a Password
			$pl=rand(8,12); //Len of Password
			$passw=substr(md5(uniqid(mt_rand(), true)), 0, $pl);         //Make random password
//--------------------------------------

//--------------------------------------
			//Create Birthdate
			$month=rand(1,12);
			$day=rand(1,27);
			$year=rand(1954,1988);
			if (strlen($day)==1){$day='0'.$day;}
			if (strlen($month)==1){$month='0'.$month;}
			$birthday=$year.'-'.$month.'-'.$day;
//--------------------------------------

//--------------------------------------
			//Create Fake Rescue Email
if ($enviroment == "test") {

			$email_ending=array('@rogers.com','@ymail.com','@hushmail.com',
        										'@hotmail.com','@live.com','@yahoo.com',
        										'@aol.com','@outlook.com');
      $rvar=rand(0,7);
      $rescue_email=$email.$email_ending[$rvar];
  }
else {

	$rescue_email=$recoverEmail;
}
//--------------------------------------

//--------------------------------------
			//Set gender
      if($gtype=='1'){$gender='FEMALE';}else{$gender='MALE';}
//--------------------------------------

//=============================================

//=============================================
// Grab Android Useragent Info From Db
// Don't grab bad opera useragents


/*
      if (!mysql_connect($db_host, $db_user, $db_pwd))    die("Can't connect to database");
      if (!mysql_select_db($database))    die("Can't select database");
      $result = mysql_query("SELECT * FROM `android_uagents_usonly` where uagent NOT Like '%opera%' order by RAND() LIMIT 1");
      $row = mysql_fetch_array ($result);
*/
 	  $uagent=  $useragent;//$row['uagent'];
      $uagentbk=$uagent;
      $uagent = get_string('(', ')', $uagent); 
      $uagent=end(explode(';', $uagent));
      $uitems=explode('/',$uagent);
      $device=$uitems[0];
      $device=str_replace('Build','',$device);
      $device=trim($device);
      $build=$uitems[1];

//=============================================

//=============================================
// Create Unique UserAgent
      $agent='GoogleLoginService/1.2 ('.$device.' '.$build.')';
//=============================================


//=============================================
// Delay to appear more natural
			SpecialSleep('1000000','2500000'); //1 to 2.5 seconds
//=============================================

//=============================================
// Set Come Variables
			$email=$email.'@gmail.com';
			$username=$email;
			$version='3';    // Google Api Version
			$password=$passw;//
			$securityAnswer=$lname;
			echo 'Name: '.$full_name.'<br>';
			echo 'Username: '.$username.'<br>';
			echo 'Password: '.$password.'<br>';
			echo 'Recovery Email: '.$rescue_email.'<br>';
			echo 'User Agent: '.$agent.'<br>';
			echo 'Version: '.$version.'<br>';
//=============================================

//=============================================
// Send Post Data
			$postvar='{"username":"'.$username.'","version":"'.$version.'","firstName":"'.$fname.'","lastName":"'.$lname.'"}';
			$burl='https://android.clients.google.com/setup/checkavail';
			$result=POSTcurl($burl, $refr, $agent, $postvar, '0', $cookie_file_path, $useprxy, $proxy_ip, $proxy_port, $timeout, '0','0','');
			//echo 'result: '.$result.'<br>'; //Debug Data
//=============================================

//=============================================
// Check For Success
			if ($result== 'error' || $result=='') {
				echo 'Bad Proxy Account -Error';
				echo 'Connection Error:<br>';
				exit();
			}
//=============================================

//=============================================
// Check If Username Available
			if (strpos($result, '"suggestions"') !== false) {
				$username= get_string('"suggestions":["', '"]', $result);
				$suguser=str_replace('"','',$username);
				$username=end(explode(',', $suguser));
				$email=$username;
				echo 'New Username: '.$username.'<br>';
			}else{
				echo 'Username Available! '.'<br>';
			}
//=============================================

//=============================================
// Delay to appear more natural
			SpecialSleep('1000000','2500000'); //1 to 2.5 seconds
//=============================================

//=============================================
// Send Post Data
			$postvar='{"username":"'.$username.'","version":"'.$version.'","password":"'.substr($password, 0,(strlen($password)/2)).'","firstName":"'.$fname.'","lastName":"'.$lname.'"}';
			$burl='https://android.clients.google.com/setup/ratepw';
			$result=POSTcurl($burl, $refr, $agent, $postvar, '0', $cookie_file_path, $useprxy, $proxy_ip, $proxy_port, $timeout, '0','0','');
			//echo 'result: '.$result.'<br>'; //Debug Data
//=============================================

//=============================================
// Delay to appear more natural
			SpecialSleep('1000000','2500000'); //100 to 800 ms
//=============================================

//=============================================
// Send Post Data
			$postvar='{"username":"'.$username.'","version":"'.$version.'","password":"'.$password.'","firstName":"'.$fname.'","lastName":"'.$lname.'"}';
			$burl='https://android.clients.google.com/setup/ratepw';
			$result=POSTcurl($burl, $refr, $agent, $postvar, '0', $cookie_file_path, $useprxy, $proxy_ip, $proxy_port, $timeout, '0','0','');
			//echo 'result: '.$result.'<br>'; //Debug Data
//=============================================

//=============================================
// Delay to appear more natural
			SpecialSleep('1000000','2500000'); //1 to 2.5 secs
//=============================================

//=============================================
// Check For Success
			if (strpos($result, 'SUCCESS') == false) {
				echo 'Failed Step2: '.$result.'<br>';
				exit();
			}else{
				echo 'Good Step2: <br>';
			}
//=============================================

//=============================================
// Delay to appear more natural
			SpecialSleep('3000000','6000000'); //3 to 6 secs
//=============================================

//=============================================
// Create Android ID
			$androidID=substr(md5(uniqid(mt_rand(), true)), 0, 16);
			echo 'AndroidID: '.$androidID.'<br>';
//=============================================

//=============================================
// Send Post Data
			$postvar='{"androidId":"'.$androidID.'","operatorCountry":"us","device_country":"us","lang":"en","firstName":"'.$fname.'","lastName":"'.$lname.'"}';
			$burl='https://android.clients.google.com/setup/checkname';
			$result=POSTcurl($burl, $refr, $agent, $postvar, '0', $cookie_file_path, $useprxy, $proxy_ip, $proxy_port, $timeout, '0','0','');
			//echo 'result: '.$result.'<br>'; //Debug Data
//=============================================

//=============================================
// Check For Successful ID
			if (strpos($result, 'SUCCESS') == false) {
				echo 'Failed Step3: '.$result.'<br>';
				exit();
			}else{
				echo 'Good Step3: <br>';
			}
//=============================================

//=============================================
// Delay to appear more natural
			SpecialSleep('1500000','4000000'); //1.5 to 4 secs
//=============================================

//=============================================
// Create Answers For Security Question
			$areaarray= array('780', '403', '907', '205', '256', '334', '251', '870', '501', '479', '480', '623', '928', '602', '520', '250', '778', '604', '628', '341', '764', '925', '909', '562', '661', '657', '510', '650', '949', '760', '415', '951', '752', '831', '209', '669', '408', '559', '626', '442', '530', '916', '707', '627', '714', '310', '323', '213', '424', '747', '818', '858', '935', '619', '805', '369', '720', '303', '970', '719', '203', '959', '475', '860', '202', '302', '689', '407', '239', '836', '727', '321', '754', '954', '352', '863', '904', '386', '561', '772', '786', '305', '861', '941', '813', '850', '478', '770', '470', '404', '706', '678', '912', '229', '671', '808', '515', '319', '563', '641', '712', '208', '217', '282', '872', '312', '773', '464', '708', '815', '224', '847', '618', '331', '630', '765', '574', '260', '219', '317', '812', '913', '785', '316', '620', '327', '502', '859', '606', '270', '504', '985', '225', '318', '337', '774', '508', '781', '339', '857', '617', '978', '351', '413', '204', '443', '410', '280', '249', '969', '240', '301', '207', '383', '517', '546', '810', '278', '313', '586', '248', '734', '269', '906', '989', '616', '231', '679', '947', '612', '320', '651', '763', '952', '218', '507', '636', '660', '975', '816', '314', '557', '573', '417', '670', '601', '662', '228', '406', '52+55', '506', '336', '252', '984', '919', '980', '910', '828', '704', '701', '402', '308', '709', '603', '908', '848', '732', '551', '201', '862', '973', '609', '856', '505', '957', '902', '702', '775', '315', '518', '716', '646', '347', '718', '212', '516', '917', '845', '631', '607', '914', '216', '330', '234', '567', '419', '380', '440', '740', '614', '283', '513', '937', '918', '580', '405', '705', '289', '905', '647', '416', '613', '519', '807', '503', '971', '541', '814', '717', '570', '358', '878', '835', '484', '610', '445', '267', '215', '724', '412', '939', '787', '438', '514', '819', '418', '450', '401', '843', '864', '803', '605', '306', '423', '865', '931', '615', '901', '731', '254', '325', '713', '940', '817', '430', '903', '806', '737', '512', '361', '210', '936', '409', '979', '972', '469', '214', '682', '832', '281', '830', '956', '432', '915', '435', '801', '385', '434', '804', '757', '703', '571', '540', '276', '381', '236', '802', '509', '360', '564', '206', '425', '253', '715', '920', '414', '262', '608', '353', '420', '304', '307', '867');
			$areacode = $areaarray[rand(0,count($areaarray)-1)];
			$fakephone=$areacode.rand(210, 289).rand(1321,9821);
			$fakefname=$fname.'s'; //Change to actual name
			$fakelname=$fname.'s'; //Change to actual name
//=============================================

//=============================================
// Create Security Question & Answer
			$securityQ_arry=array('First phone number?','Childhood best friend\'s name?','First teacher\'s name?', 'Manager\'s name at first job?');
			$securityA_arry=array($fakephone,$fakelname,$fakefname,$fakelname);
			$rn=rand(0,3);
			$securityQ=$securityQ_arry[$rn];
			$securityA=$securityA_arry[$rn];
			echo 'securityQ: '.$securityQ.'<br>';
			echo 'securityA: '.$securityA.'<br>';
//=============================================

//=============================================
// Send Post Data
// Create Actual Account
			$postvar='{"androidId":"'.$androidID.'","username":"'.$email.'","securityAnswer":"'.$securityA.'","securityQuestion":"'.$securityQ.'","secondaryEmail":"'.$rescue_email.'","version":"'.$version.'","password":"'.$password.'","firstName":"'.$fname.'","lastName":"'.$lname.'","agreeWebHistory":"0","locale":"en_US","operatorCountry":"us","simCountry":"us"}';
			$burl='https://android.clients.google.com/setup/create';
			$result=POSTcurl($burl, $refr, $agent, $postvar, '0', $cookie_file_path, $useprxy, $proxy_ip, $proxy_port, $timeout, '0','0','');
			//echo 'result: '.$result.'<br>'; //Debug Data
//=============================================

//=============================================
// Check For Success & Captcha
			if (strpos($result, 'CAPTCHA') == false) {
				echo 'Failed Step 4 Captcha: '.$result.'<br>';
				exit();
			}else{
				echo 'Good Step4: <br>';
				$captchaB64= get_string('"captchaData":"', '"', $result);
				$captchaB64=str_replace("\u003d","",$captchaB64);
				$captchaMime= get_string('"captchaMime":"', '"', $result);
				$captchaToken= get_string('"captchaToken":"', '"', $result);
			}
//=============================================


//=============================================
// Grab and save Captcha Data
			$file_path = $savePath."captcha".$reqid.$uid.".jpg";
			file_put_contents($file_path, base64_decode($captchaB64));
//=============================================

//=============================================
// Captcha Solving Engine
// $file_path contains path to file to send to
      $answer = solve_captcha($zeeHost,$key,$bid,$file_path,$ca_file);

			if ($answer != false) {
				echo 'Captcha Answer:'.$answer.'<br>';
			}else{
				echo 'Captcha did not return!<br>';
				exit();
			}
//=============================================

//=============================================
// Send Post Data - Final Step
			$postvar='{"androidId":"'.$androidID.'","username":"'.$email.'","securityAnswer":"'.$securityA.'","securityQuestion":"'.$securityQ.'","secondaryEmail":"'.$rescue_email.'","version":"'.$version.'","password":"'.$password.'","firstName":"'.$fname.'","lastName":"'.$lname.'","captchaToken":"'.$captchaToken.'","captchaAnswer":"'.$answer.'","agreeWebHistory":"0","locale":"en_US","operatorCountry":"us","simCountry":"us"}';
			$burl='https://android.clients.google.com/setup/create';
			$result=POSTcurl($burl, $refr, $agent, $postvar, '0', $cookie_file_path, $useprxy, $proxy_ip, $proxy_port, $timeout, '0','0','');
			//echo 'result: '.$result.'<br>'; //Debug Data
//=============================================

//=============================================
// Check For Success
			if (strpos($result, 'SUCCESS') == false) {
				echo 'Failed Step5: '.$result.'<br>';
				exit();
			}else{
				echo 'Good Step5: <br>';
			}
//=============================================
//echo $postvar;


// Write created info to json file
echo $email;
echo $password;
$jsonstuff = '{"username":"'.$email.'", "password":"'.$password.'","securityA":"'.$securityA.'","recoverEmail":"'.$rescue_email.'"}';
$json_file_path = $savePath."\ginfo.json";
file_put_contents($json_file_path, $jsonstuff);

save_account_info($zeeHost, $key, $bid, $email, $password, $securityA, $ca_file);

//echo $jsonstuff;


//=============================================
// Success - Account Created - Save
			echo 'Success: Account Created<br> -- ';
			echo $email;
			echo " -- ";
			echo $password;

//=============================================

//=============================================
// Login To Account, 
// **Phone Verify it right away** !important
// Login only for ip used to make account
//include "gmail_login.php"
//include "phone_verification.php"
//=============================================


SpecialSleep('1500000','21000000');


//=============================================
// Version 3 of Google Account Login
//=============================================

//=============================================
// Allow script to not timeout
     // ini_set('max_execution_time', 0);
      //set_time_limit(0);
      //ignore_user_abort(true);


$loginpassw = '';
$username = $email;
//=============================================

//=============================================
//Basic Setting / Required Imports
      //require_once "db.php";    // Include Database Info
      //require_once "curl.php";  // Contains Curl Librarys
//=============================================

//=============================================
// Login Variables
      //---------------------------------------
      // Test Variables
      //$username='YeseniaGicker@gmail.com';
      //$password='5eeddff1';
      //$rescue_email='YeseniaGicker2@ymail.com';
      //$agent='GoogleLoginService/1.2 (MB886 9.8.0Q-97_MB886_FFW-20)';
      //$phone='17272045845';
      //$proxy_ip='89.47.31.1';// 89.47.31.176:8800';//$tmpp[0];
      //$proxy_port='8800';//$tmpp[1];
      //$useprxy=1; //Turn proxy on/off
      //$timeout='40';//set timeout to 20 seconds
      //-----------------------------------------
      
      $username=urlencode($username);
      $phone_formatted= preg_replace('~.*(\d{3})[^\d]*(\d{3})[^\d]*(\d{4}).*~', '($1)%20$2-$3', $phone); //(727)%20204-5859
//=============================================

//=============================================
// Create New Unique Cookie File
    //  $cookie_file_path = dirname(__FILE__)."/cookies/".$reqid.$uid."google_cookie.txt"; // 
    //  $fp = fopen($cookie_file_path,'wb');
    //  fclose($fp);

  if ($enviroment == "test")
  {
    $cookie_file_path = dirname(__FILE__)."/google/google_cookie.txt"; // /
    $fp = fopen($cookie_file_path,'wb');
    fclose($fp);
  }
  else
  {
    $cookie_file_path = $savePath."\google_cookie.txt"; // /
    $fp = fopen($cookie_file_path,'wb');
    fclose($fp);

  } 
//=============================================
  if ($enviroment == "test") {
  echo "HERE IS THE INFO IN THE LOGIN:--- $username ---- $password";
}
//=============================================
// Delay to appear more natural
      SpecialSleep('500000','1000000');
//=============================================

//=============================================
// Grab Page Data
      $burl2='https://mail.google.com/mail/';
      $refr='https://www.google.com';
      $result=GETcurl($burl2, $refr, $agent, '1', $cookie_file_path, $useprxy, $proxy_ip, $proxy_port, $loginpassw, $timeout, '0');
      //echo 'result: '.$result.'<br>'; //Debug Data
//=============================================

//=============================================
// Check If Proxy Is Okay
      if ($result=='' || $result=='error') {echo 'Proxy Failed To Connect<br>';exit();}       
//=============================================   

//=============================================
// Check If Account Is Okay
      if (strpos($result, 'sorry') !== false) {echo 'Account Banned<br>';exit();}       
//=============================================

//=============================================
//Grab Google Variables
      $tmp = get_string('name="GALX"', '>', $result);
      $GALX= get_string('value="', '"', $tmp);
      $tmp = get_string('id="dsh"', '>', $result);
      $dsh= get_string('value="', '"', $tmp);
      $tmp = get_string('id="continue"', '>', $result);
      $continue= get_string('value="', '"', $tmp);
      $continue=str_replace('&amp;','&',$continue);
      $tmp = get_string('id="nui"', '>', $result);
      $nui= get_string('value="', '"', $tmp);
      $tmp = get_string('id="ltmpl"', '>', $result);
      $ltmpl= get_string('value="', '"', $tmp);
      $tmp = get_string('id="btmpl"', '>', $result);
      $btmpl= get_string('value="', '"', $tmp);
      $tmp = get_string('id="scc"', '>', $result);
      $scc= get_string('value="', '"', $tmp);
//=============================================

//=============================================
// Send Google Tracking
      $date = new DateTime();
      $tstamp=$date->getTimestamp().'000';
      $burl2='https://mail.google.com/mail?gxlu='.$username.'&zx='.$tstamp;
      $refr='https://www.google.com';
      $result=GETcurl($burl2, $refr, $agent, '1', $cookie_file_path, $useprxy, $proxy_ip, $proxy_port, $loginpassw, $timeout, '0');
      //echo 'result: '.$result.'<br>'; //Debug Data
//=============================================

//=============================================
// Delay to appear more natural
      SpecialSleep('1000000','3000000');
//=============================================

//=============================================
// Send Google Tracking Level 2
      $date = new DateTime();
      $tstamp=$date->getTimestamp().'001';
      $burl2='https://mail.google.com/mail?gxlu='.$password.'&zx='.$tstamp;
      $refr='https://www.google.com';
      $result=GETcurl($burl2, $refr, $agent, '1', $cookie_file_path, $useprxy, $proxy_ip, $proxy_port, $loginpassw, $timeout, '0');
      //echo 'result: '.$result.'<br>'; //Debug Data
//=============================================

//=============================================
// Delay to appear more natural
      SpecialSleep('1000000','3000000');
//=============================================

//=============================================
// Send Post Data
      $postvar='continue='.urlencode($continue);
      $postvar=$postvar.'&service=mail';
      $postvar=$postvar.'&nui='.$nui;
      $postvar=$postvar.'&dsh='.$dsh;
      $postvar=$postvar.'&ltmpl='.$ltmpl;
      $postvar=$postvar.'&btmpl='.$btmpl;
      $postvar=$postvar.'&scc='.$scc;
      $postvar=$postvar.'&GALX='.$GALX;
      $postvar=$postvar.'&timeStmp=&secTok=&_utf8=%E2%98%83';
      $postvar=$postvar.'&bgresponse=%21A0J0SYB0ju25E0TGozoTtCh9JQIAAAAxUgAAAAYqAQk9azZMLW6MAV4IRSOTiSYLyuvRzqLvG3lUPdHFX5ND618m0zSh5PxLoEt2Wfnp-owPtnHNHCLKQqcUVPW5zqYicsEaqMKAGbVTJBAIZBAIntLUghtM-jMj5R6i_SCyqx-DvtjJcEy8fo8OqPbbSBuIqJsqr2eejYZC8Sk36rzaD2lNZzZs0ED11QtE86_9d0Ijy79-8P94jaLww8t65KgPRXJcHBfjP-4FGTPv0ccki3SuoFdLOKkWKNiiLwLfP5pYGJ66jmUuosI0Y_1FsI5qdf6xJsl_Pv2fZzvLq3wZvjD7gG9pE3QIGYVcvyuqng675M_U-AwIguX7ySsWldNobSLH7_NMRZCp';
      $postvar=$postvar.'&Email='.$username;
      $postvar=$postvar.'&Passwd='.$password;
      $postvar=$postvar.'&signIn=Sign+in&PersistentCookie=yes&rmShown=1';
      
      $burl='https://accounts.google.com/ServiceLoginAuth';
      $refr='https://accounts.google.com/ServiceLogin?service=mail&passive=true&rm=false&continue=https://mail.google.com/mail/&ss=1&scc=1&ltmpl=default&ltmplcache=2&hl=en';
      $result=POSTcurl($burl, $refr, $agent, $postvar, '1', $cookie_file_path, $useprxy, $proxy_ip, $proxy_port, $timeout, '1','0','');
      //echo 'result: '.$result.'<br>'; //Debug Data
//=============================================

//=============================================
// Check For Success
      if ($result=='' || $result=='error') {echo 'Proxy Failed To Connect<br>';exit();}
//=============================================

//=============================================
// Check User/Pass Okay
      if (strpos($result, 'The username or password you entered is incorrect.') !== false) {echo 'User/Pass Incorrect<br>';exit();}
//=============================================

//=============================================
// Check For Account Instant Disabled
      if (strpos($result, 'http://www.google.com/support/accounts/bin/answer.py?answer=40695') !== false) {echo 'Account Disabled<br> Check For Blacklisted Proxy';exit();}
//=============================================

//=============================================
// Check For Phone Verification Required
      if (strpos($result, '/IdvReenable') !== false) {
        echo 'Account Needs New Phone Reenabled<br>';
        //include "gmail_idvreenable_phone_verify.php";//Phone Verification 1 
        exit();
      }
//=============================================

//=============================================
// Check For When Suspicious Activity Detected
// Verify your identity
// Should Never Happen - Not Implemented
      if (strpos($result, 'action="LoginVerification"') !== false) {
        echo 'Verify your identity<br>';
        //continue=https%3A%2F%2Fmail.google.com%2Fmail%2F&service=mail&_utf8=%26%239731%3B&bgresponse=%21A0KwPNGCtRbxREQi7yxKVMxWzQ8ABB4IIsYqAVZtd0Dpb_6FSCoU4oetrYO1ZdcLffpoq2NJBHN7xHHBijTOFZLYYFq-MSWO4RZiglBPU8eulOJDP1WuM29rOwhwwEJM05rwItnQMM6edmWfAZ2ujgLs8XOWK3JW8kPyTeM6Ix2NRtZqva2hoa4ejMORVxlTZ8WtCfmidyEkCNHYFruN5dzuCUKG2bScqQbShyHvaZVBdQQhsBC5-Ky10vr-zJdflpvK7Oy2EDWf65s6_UzpgU2bK1mw3u4vP4EJmhM0QbpvnL9jtO0hZP83OSlyWDJ4Qi2lPCPQ9KpJQpM5XqB1OymkO9Sd2uw25utfwRHg7NacYfFQemuAmEamm63l8qes_GgeDFpwyzNwiGASnUYKORM17zKzAJlSxRozaUIyM75qhp17XsrFORaXYwpMFpksaA7xWNn-5tfv_7g1auHZxGPk6WOW9PMxEwaRGDft_9FJiqI
        // Use phone to prove
        //&challengestate=&challengetype=PhoneVerificationChallenge&phoneNumber='.$phone.'&emailAnswer=&answer=
        // Or Use recovery email below
        //&challengestate=&challengetype=RecoveryEmailChallenge&phoneNumber=&emailAnswer='.$rescue_email.'&answer=
        exit();
      }
//=============================================

//=============================================
      echo 'Good Login<br>';
//=============================================

//=============================================
// Delay to appear more natural
      SpecialSleep('1000000','3000000');
//=============================================

//=============================================
// Grab Page Data -Update Google Settings
      $burl2='https://accounts.google.com/b/0/UpdateAccountRecoveryOptions?hl=en';
      $refr='https://mail.google.com/mail/';
      $result=GETcurl($burl2, $refr, $agent, '1', $cookie_file_path, $useprxy, $proxy_ip, $proxy_port, $loginpassw, $timeout, '0');
      //echo 'result: '.$result.'<br>';exit(); //Debug Data
//=============================================

//=============================================
// Check For Success
      if (strpos($result, 'action="UpdateAccountRecoveryOptions"') == false) {echo 'Error: Could Not access Settings<br>';exit();}
//=============================================

//=============================================
//Grab Google Variables
      $tmp = get_string('name="timeStmp"', '>', $result);
      $timeStmp = get_string("value='", "'", $tmp);
      $tmp = get_string('name="secTok"', '>', $result);
      $secTok = get_string("value='", "'", $tmp);
      $tmp = get_string('name="customSecretQuestion"', '>', $result);
      $customSecretQuestion = get_string('value="', '"', $tmp);
      $tmp = get_string('name="secretAnswer"', '>', $result);
      $secretAnswer = get_string('value="', '"', $tmp);
//=============================================

//=============================================
// Delay to appear more natural
      SpecialSleep('1000000','3000000');
//=============================================

//=============================================
// Send Post Data - Update Recovery Phone Number & Email
      $postvar='timeStmp='.$timeStmp;
      $postvar=$postvar.'&secTok='.urlencode($secTok);
      $postvar=$postvar.'&mobileCountry=US';
      $postvar=$postvar.'&mobileNumber='.$phone;
      $postvar=$postvar.'&mobileAddressEnabled=1';
      $postvar=$postvar.'&secondaryEmailAddress='.urlencode($rescue_email);
      $postvar=$postvar.'&resend=&Email=&secretQuestion=customSecretQuestion';
      $postvar=$postvar.'&customSecretQuestion='.urlencode($customSecretQuestion);
      $postvar=$postvar.'&secretAnswer='.$secretAnswer;
      $postvar=$postvar.'&save=Save';
      
      $burl='https://accounts.google.com/b/0/UpdateAccountRecoveryOptions';
      $refr='https://accounts.google.com/b/0/UpdateAccountRecoveryOptions?hl=en';
      $result=POSTcurl($burl, $refr, $agent, $postvar, '1', $cookie_file_path, $useprxy, $proxy_ip, $proxy_port, $timeout, '1','0','');
      //echo 'result: '.$result.'<br>';exit(); //Debug Data
//=============================================

//=============================================
// Check For Account Info Saved
if ($enviroment == "test") {
file_put_contents("save_settings_result.txt", $result);
}

      if (strpos($result, 'Your account information has been updated and saved') == false) {echo 'Error: Could Not Save Settings<br>';exit();}else{echo 'Google Account Settings Saved<br>';}
//=============================================


//###############################################################
//###############################################################
// Do The Phone Verifiction

//=============================================
// Delay to appear more natural
      SpecialSleep('1000000','3000000');
//=============================================

//=============================================
// Grab Page Data -Phone Verify
      $burl2='https://accounts.google.com/b/0/AccountRecoveryAddVerifiedPhone?hl=en';
      $refr='https://mail.google.com/mail/';
      $result=GETcurl($burl2, $refr, $agent, '1', $cookie_file_path, $useprxy, $proxy_ip, $proxy_port, $loginpassw, $timeout, '0');
      //echo 'result: '.$result.'<br>';exit(); //Debug Data
//=============================================

//=============================================
// Check For Success
      if (strpos($result, 'action="AccountRecoveryAddVerifiedPhone"') == false) {echo 'Error: Could Not access Phone Verify Page<br>';exit();}else{echo 'Good access of phone verify page<br>';}
//=============================================

//=============================================
//Grab Google Variables
      $tmp = get_string('name="timeStmp"', '>', $result);
      $timeStmp = get_string("value='", "'", $tmp);
      $tmp = get_string('name="secTok"', '>', $result);
      $secTok = get_string("value='", "'", $tmp);
      
      $tmp = get_string('verifyRecoveryPhoneClient = new gaia.Client(', ')', $result);
      $timeStmp = get_string("',", "',", $tmp);
      $timeStmp = str_replace("'", "", $timeStmp);
      $timeStmp = trim($timeStmp);
      $tmp = get_string('verifyRecoveryPhoneClient = new gaia.Client(', ')', $result);
      $secTok = get_string("'", "'", $tmp);
      echo 'timeStmp: '.$timeStmp.'<br>'; 
      echo 'secTok: '.$secTok.'<br>'; 
//=============================================

//=============================================
// Delay to appear more natural
      SpecialSleep('1000000','3000000');
//=============================================

//=============================================
// Send Post Data - Tell Google Our Phone 4 Verify
      $postvar='deliveryMethod=textMessage';
      $postvar=$postvar.'&deviceAddress='.$phone_formatted; //(727)%20204-5859
      $postvar=$postvar.'&deviceCountry=US';
      $postvar=$postvar.'&deviceCarrier';
      $postvar=$postvar.'&deviceCarrierDomain';
      $postvar=$postvar.'&SendCode=1';
      $postvar=$postvar.'&secTok='.urlencode($secTok);
      $postvar=$postvar.'&timeStmp='.$timeStmp;
      $burl='https://accounts.google.com/b/0/VerifyRecoveryPhone';
      $refr='https://accounts.google.com/b/0/AccountRecoveryAddVerifiedPhone?hl=en';
      $result=POSTcurl($burl, $refr, $agent, $postvar, '1', $cookie_file_path, $useprxy, $proxy_ip, $proxy_port, $timeout, '1','0','');
      //echo 'result: '.$result.'<br>'; //Debug Data
//=============================================

//=============================================
// Check For Success
if ($enviroment == "test") {
  file_put_contents("sendto_google_result.txt", $result);
}

      if (strpos($result, '"success":true') == false) {echo 'Error: Failed sending phone to google<br>'; exit();}
//=============================================

//=============================================
//Grab Google Variables
      $idvToken = get_string('"idvToken":"', '"', $result);
//=============================================

//=============================================
// Get The Pin That google sent.
      echo 'Grab The Pincode Sent From Google<br>';
      


phone_verify($zeeHost,$key,$bid,$file_path,$ca_file);


      //$pincode='';
      //exit();


//=============================================

//=============================================
// Send Post Data - Confirm Pincode Received
      $postvar='deliveryMethod=textMessage';
      $postvar=$postvar.'&deviceAddress='.$phone_formatted;
      $postvar=$postvar.'&deviceCountry=US';
      $postvar=$postvar.'&deviceCarrier';
      $postvar=$postvar.'&deviceCarrierDomain';
      $postvar=$postvar.'&idvToken='.$idvToken;
      $postvar=$postvar.'&smsUserPin='.$pincode;
      $postvar=$postvar.'&VerifyPhone=1';
      $postvar=$postvar.'&secTok='.urlencode($secTok);
      $postvar=$postvar.'&timeStmp='.$timeStmp;
      

if ($enviroment == "test") {
echo "BEGIN POSTVAR - - - - $postvar   - - - - END POST VAR";
}


      $burl='https://accounts.google.com/b/0/VerifyRecoveryPhone';
      $refr='https://accounts.google.com/b/0/AccountRecoveryAddVerifiedPhone?hl=en';
      $result=POSTcurl($burl, $refr, $agent, $postvar, '1', $cookie_file_path, $useprxy, $proxy_ip, $proxy_port, $timeout, '1','0','');
      //echo 'result: '.$result.'<br>'; //Debug Data
//=============================================

//=============================================
// Check For Success

if ($enviroment == "test") {
      file_put_contents("final_result.txt", $result);
    }
      if (strpos($result, '"success":true') == false) {echo 'Error: Failed confirming pincode<br>';exit();}
//=============================================

//=============================================
// Tell Successful and logout
      echo 'Success Account Phone Verified';
      $burl2='https://accounts.google.com/Logout?hl=en';
      $refr='https://mail.google.com/mail/';
      $result=GETcurl($burl2, $refr, $agent, '1', $cookie_file_path, $useprxy, $proxy_ip, $proxy_port, $timeout, '0');
      //echo 'result: '.$result.'<br>'; //Debug Data      
//=============================================

//###############################################################
//###############################################################


?>
