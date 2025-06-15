<?php
include_once('auth_ssh.class.php');
require_once("POClasses/User.class.php");

$loggedIn = false;

$au = new auth_ssh();

if (array_key_exists('action', $_POST)) {
  switch ($_POST['action']) {
    case 'login':
      $login = htmlspecialchars($_POST['login'], ENT_QUOTES, 'UTF-8');
      $password = htmlspecialchars($_POST['password'], ENT_QUOTES, 'UTF-8');
      $loggedIn = $au->login($login, $password, $_SERVER['HTTP_REFERER']);
      if (!$loggedIn)
        header('Location:login.php?authStatus=failed');
      else if ($au->isAdminOrPrep())
        header('Location:mainpage.php');
      else
        header('Location:mainpage_student.php');
      exit();
      break;
    case 'logout':
      $au->logout();
      header('Location:login.php');
      break;
    default:
      http_response_code(401);
      exit;
      break;
  }
} else {
  http_response_code(401);
  exit;
}
