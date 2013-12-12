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



// Grab the citation host

if (getenv("CITATION_HOST"))
{
	$zeeHost = getenv("CITATION_HOST");
}
else
{
	$zeeHost = "https://citation.netversa.com";
}

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

?>
