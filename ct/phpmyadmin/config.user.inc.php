<?php
/* Override Servers array */
$cfg['AllowThirdPartyFraming'] = true;
$cfg['TableNavigationLinksMode'] = 'both';
$cfg['ActionLinksMode'] = 'both';
$cfg['RowActionType'] = 'icons';
$cfg['Servers'] = [
    1 => [
        'user' => 'root',
        'password' => 'root',
        'auth_type' => 'config',
        'host' => 'todo-mysql',
        'port' => 3306,
        'verbose' => 'SIDT Todo App Database',
    ],

];
