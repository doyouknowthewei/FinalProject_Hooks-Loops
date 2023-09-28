<?php
include 'User.php';
class client extends User {


    function addUser($username, $firstname, $lastname, $email, $pswd, $address, $phonenumber,$userTypeValue) {
        $sql = "CALL AddUser('$username', '$firstname', '$lastname', '$email','$pswd', '$address', '$phonenumber', '$userTypeValue')";
        $result = mysqli_query($this->dbConnect,$sql);
       
    }



 function addCart($CusID) {
    $sql = "CALL addCArt('$CusID')";
    $result = mysqli_query($this->dbConnect,$sql);
   
}


function addToCart($Pid, $Cid, $Q) {
    $sql = "CALL addToCart('$Pid', '$Cid', '$Q')";
    $result = mysqli_query($this->dbConnect,$sql);
  
}

function sendMessage($mess, $Cind, $Aid){
    $sql = "CALL sendMessage('$mess','$Cind','$Aid')";
    $result = mysqli_query($this->dbConnect,$sql);
  
   


}

function getCart($Cusid){
    $sql = "CALL getCart('$Cusid')";
    $result = mysqli_query($this->dbConnect,$sql);


}

function getCartC ($Cartid){
    $sql = "CALL getCartC('$Cartid')";
    $result = mysqli_query($this->dbConnect,$sql);

}

function deleteCart($Cid){
    $sql = "CALL deleteCart('$Cid')";
    $result = mysqli_query($this->dbConnect,$sql);

}


}


?>



