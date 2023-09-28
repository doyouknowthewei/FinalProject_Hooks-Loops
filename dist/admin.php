<?php
include 'User.php';
class Admin extends User{
    


    //addProduct
    public function AddProduct($prodname,$description,$price,$stock,$category){
        $sql= "CALL AddProduct('$prodname','$description','$price','$stock','$category')";
        mysqli_query($this->dbConnect,$sql);  
    }  





    
    //getCustomer
    public function AddUser($uname,$fname,$lname,$email,$pass,$address,$phone,$utype){
        $sql= "CALL AddUser('$uname','$fname','$lname','$email','$pass','$address','$phone','$utype')";
        $result = mysqli_query($this->dbConnect,$sql);
        if (!$result) {
            die("Error: " . mysqli_error($this->dbConnect));
        }
    }    
    //getCategory
    public function AddCategory($name,$description){
        $sql= "CALL AddCategory('$name','$description')";
        $result = mysqli_query($this->dbConnect,$sql);
        if (!$result) {
            die("Error: " . mysqli_error($this->dbConnect));
        }
    }
    //sendMessage
    public function sendMessage($message,$customid,$admid){
        $sql= "CALL sendMessage('$message','$customid','$admid')";
        $result = mysqli_query($this->dbConnect,$sql);
        if (!$result) {
            die("Error: " . mysqli_error($this->dbConnect));
        }
    }
    //receiveMessage
    public function receiveMessage($message,$customid,$admid){
        $sql= "CALL receiveMessage('$message','$customid','$admid')";
        $result = mysqli_query($this->dbConnect,$sql);
        if (!$result) {
            die("Error: " . mysqli_error($this->dbConnect));
        }
    }   
}
?>
