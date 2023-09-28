<?php 
    class User{
        private $host  = 'localhost';
        private $user  = 'root';
        private $password = '';
        private $database  = 'hooksloops';
        protected $dbConnect = false;
        
        public function __construct(){
            $conn = new mysqli($this->host, $this->user, $this->password, $this->database);
            if($conn->connect_error){
                die("Error failed to connect to MySQL: " . $conn->connect_error);
            }else{
                $this->dbConnect = $conn;
            }
        }
        
        public function LogIn($acc,$pass){
            $query = "CALL login('$acc','$pass')";
            $result = mysqli_query($this->dbConnect, $query);
            $data= array();

            if ($result !== true) {
                while ($row = mysqli_fetch_array($result, MYSQLI_ASSOC)) {
                    $data[]=$row; 
                }
            }
            return $data;
        }
    
        public function LogInCheck(){
            if(!isset($_SESSION['name'])){
                header("Location:Test.php");
            }
        }
        public function getProducts() {
            $sql = "SELECT * FROM product"; 
            $result = mysqli_query($this->dbConnect, $sql);   
            if ($result) {
                $products = array(); // Initialize the products array outside the loop
                while ($product = mysqli_fetch_assoc($result)) {
                    $prodname = $product['ProductName']; 
                    $price = $product['Price']; 
                    $stock = $product['Stock'];  
        
                    echo '<div class="item features-image сol-12 col-md-6 col-lg-3 active">';
                    echo '<div class="item-wrapper">';
                    echo '<div class="item-img">';
                    echo '<img src="..\pictures\gallery1.jpg" alt=""/>';
                    echo '</div>';
                    echo '<div class="item-content">';
                    echo '<p class="mbr-text mbr-fonts-style mt-3 mb-0 display-4">' . $prodname . '</p>';
                    echo '<p class="mbr-text mbr-fonts-style mt-3 mb-0 display-4">$' . $price . '</p>';
                    echo '<p class="mbr-text mbr-fonts-style mt-2 mb-0 display-4">Stock:' . $stock . '</p>';
                    echo '<div class="mbr-section-btn mt-4 mb-5">';
                    echo '<a class="btn btn-success display-4" href="#">BUY NOW</a>';
                    echo '</div>';
                    echo '</div>';
                    echo '</div>';
                    echo '</div>';
        
                    $products[] = $product; // Append each product to the products array
                }
                mysqli_free_result($result);
        
                return $products;
            } else {
                return false;
            }
        }

    }
?>