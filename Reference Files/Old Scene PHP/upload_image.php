<?php
    $name = $_GET['name'];
    $name = filter_var($name, FILTER_SANITIZE_STRING);
    
    $width = $_GET['width'];
    $width = filter_var($width, FILTER_SANITIZE_NUMBER_INT);
    
    $height = $_GET['height'];
    $height = filter_var($height, FILTER_SANITIZE_NUMBER_INT);
    
    if($_FILES['photo']['name'])
    {
        if(!$_FILES['photo']['error'])
        {
            $new_file_name = strtolower($_FILES['photo']['tmp_name']); //rename file
            if($_FILES['photo']['size'] > (8192000)) //can't be larger than 8 MB
            {
                $output = array('error' => 'Filesize is too large.');
                echo json_encode($output);
            }
            else
            {
                $con = mysql_connect("hypernova.db.6143131.hostedresource.com", "hypernova", "Hyp3r#N0va");
                if($con)
                {
                    $url = 'uploads/'.$name.'.jpg';
                    move_uploaded_file($_FILES['photo']['tmp_name'], $url);
                    
                    $url = 'http://www.froggystudios.com/bounce/'.$url;
                    mysql_select_db('hypernova');
                    
                    $result = mysql_query("INSERT INTO images (imageURL, width, height) VALUES ('$url', '$width', '$height');");
                    $lastID = mysql_insert_id();
                    
                    $output = array('imageURL' => $url, 'id' => $lastID);
                    echo json_encode($output);
                    mysql_close($con);
                }
            }
        }
        else
        {
            $output = array('error' => $_FILES['photo']['error']);
            echo json_encode($output);
        }
    }
?>
