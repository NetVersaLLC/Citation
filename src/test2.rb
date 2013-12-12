def enter_captcha
  captcharetries = 5
  capSolved = false
 until capSolved == true
	  captcha_code = solve_captcha2	
    @browser.execute_script("
      function getRealId(partialid){
        var re= new RegExp(partialid,'g')
        var el = document.getElementsByTagName('*');
        for(var i=0;i<el.length;i++){
          if(el[i].id.match(re)){
            return el[i].id;
            break;
          }
        }
      }
      
      _d.getElementById(getRealId('wlspispSolutionElement')).value = '#{captcha_code}';
 
      ")
      sleep(5)
 
      @browser.execute_script('
        jQuery("#SignUpForm").submit()
      ')
 
      sleep 15
 
    if @browser.url =~ /https:\/\/account.live.com\/summarypage.aspx/i
      capSolved = true
    elsif @browser.text.include? "The email address or single-use code is incorrect. Please try again."
    	capSolved = true
    else
      captcharetries -= 1
    end
    if capSolved == true
      break
    end
 
  end
 
  if capSolved == true
    return true
  else
    throw "Captcha could not be solved"
  end
   
 
end

