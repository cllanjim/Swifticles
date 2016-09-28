<?php

    print($_FILES);
    print("1.. if they DID upload a file...\n");
    //if they DID upload a file...
    if($_FILES['photo']['name'])
    {
        print("2.. if no errors...\n");
        //if no errors...
        if(!$_FILES['photo']['error'])
        {
            print("3..\n");
            //now is the time to modify the future file name and validate the file
            $new_file_name = strtolower($_FILES['photo']['tmp_name']); //rename file
            print($new_file_name);
            print("\n\n");
            if($_FILES['photo']['size'] > (8192000)) //can't be larger than 8 MB
            {
                $valid_file = false;
                $message = 'Oops!  Your file\'s size is to large.';
                print("Fail 1 .. Oops!  Your file\'s size is to large.\n");
            }
            else
            {
                print("VALID FILE!!!!");
                //move it to where we want it to be
                move_uploaded_file($_FILES['photo']['tmp_name'], 'uploads/image.png');
                $message = 'Congratulations!  Your file was accepted.';
            }
            
            print("4..\n");
            
            //if the file has passed the test
            
        }
        //if there is an error...
        else
        {
            //set that to be the returned message
            $message = 'Ooops!  Your upload triggered the following error:  '.$_FILES['photo']['error'];
        }
    }
    
?>
