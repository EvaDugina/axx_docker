<?php
require_once("settings.php");

class auth_ssh
{
    function login($login, $pwd, $source, $role = null)
    {
        global $dbconnect;
        session_start();
        $lg = pg_escape_string($login);

        if ($role != null)
            $result = pg_query($dbconnect, "SELECT * FROM students WHERE login='$lg' AND role=$role");
        else
            $result = pg_query($dbconnect, "SELECT * FROM students WHERE login='$lg'");
        $found = pg_fetch_assoc($result);
        if ($found) {
            if (($login == "admin" && $pwd == htmlspecialchars("RfatlhfkmysqFlvby")) ||
                ($login == "redbird66" && $pwd == htmlspecialchars("CthutqRfxfkjd")) ||
                ($login == "peter" && $pwd == htmlspecialchars("CneltynVbh'f")) ||
                ($login == "ivan" && $pwd == htmlspecialchars("CneltynVbh'f"))
            ) {
                $_SESSION['login'] = $login;
                $_SESSION['role'] = $found['role'];
                $_SESSION['hash'] = $found['id'];
                return $found['role'];
            }
        }

        return false;
    }

    //----------------------------------------------------------------------------------------------

    function logout()
    {
        $_SESSION['login'] = '';
        $_SESSION['role'] = 0;
        $_SESSION['hash'] = '';
        $_SESSION['username'] = '';
    }

    //----------------------------------------------------------------------------------------------

    function loggedIn($hash = "")
    {
        if (array_key_exists('login', $_SESSION)) {
            return $_SESSION['login'];
        } else
            return false;
    }

    //----------------------------------------------------------------------------------------------

    // function isTeacher($hash = '') {
    //     if (array_key_exists('role', $_SESSION)) {
    //         return ($_SESSION['role'] == 2);
    //     }
    //     else
    //         return false;
    // }

    //----------------------------------------------------------------------------------------------

    // function isStudent($hash = '') {
    //     if (array_key_exists('role', $_SESSION)) {
    //         return ($_SESSION['role'] == 3);
    //     }
    //     else
    //         return false;
    // }

    //----------------------------------------------------------------------------------------------

    function isStudent($hash = '')
    {
        if (array_key_exists('role', $_SESSION)) {
            return ($_SESSION['role'] == 3);
        } else
            return false;
    }

    //----------------------------------------------------------------------------------------------

    function isAdmin($hash = '')
    {
        if (array_key_exists('role', $_SESSION)) {
            return ($_SESSION['role'] == 1);
        } else
            return false;
    }

    //----------------------------------------------------------------------------------------------

    function isAdminOrPrep($hash = '')
    {
        if (array_key_exists('role', $_SESSION)) {
            return (($_SESSION['role'] == 1) || ($_SESSION['role'] == 2));
        } else
            return false;
    }

    //----------------------------------------------------------------------------------------------

    function getUserId($hash = '')
    {
        if (array_key_exists('hash', $_SESSION)) {
            return $_SESSION['hash'];
        } else
            return false;
    }

    //----------------------------------------------------------------------------------------------

    function getUserLogin($hash = '')
    {
        if (array_key_exists('login', $_SESSION)) {
            return $_SESSION['login'];
        } else
            return false;
    }

    //----------------------------------------------------------------------------------------------

    function getUserRole($hash = '')
    {
        if (array_key_exists('role', $_SESSION)) {
            return $_SESSION['role'];
        } else
            return false;
    }

    //----------------------------------------------------------------------------------------------
}
