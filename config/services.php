<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Third Party Services
    |--------------------------------------------------------------------------
    |
    | This file is for storing the credentials for third party services such
    | as Stripe, Mailgun, SparkPost and others. This file provides a sane
    | default location for this type of information, allowing packages
    | to have a conventional place to find your various credentials.
    |
    */

    'mailgun' => [
        'domain' => env('MAILGUN_DOMAIN'),
        'secret' => env('MAILGUN_SECRET'),
    ],

    'ses' => [
        'key' => env('SES_KEY'),
        'secret' => env('SES_SECRET'),
        'region' => 'us-east-1',
    ],

    'sparkpost' => [
        'secret' => env('SPARKPOST_SECRET'),
    ],

    'stripe' => [
        'model' => App\User::class,
        'key' => env('STRIPE_KEY'),
        'secret' => env('STRIPE_SECRET'),
    ],
	'wcf_service' => [

        'host' => 'http://localhost:1333/Service1.svc?wsdl', // server 
        // 'host' => 'http://localhost:5369/Service1.svc?wsdl', // local
        'status' => [
            "OK" => 200,    // sucess
            "NG" => 201,    // error
            "EX" => 202,    // exception
            "EPT" => 203,   // empty
            'NT' => 204,    // 
            'SCS' => 205,   //
            'NOTDATA'=>209
        ],
        'download_path'=>public_path('download')
    ]
];
