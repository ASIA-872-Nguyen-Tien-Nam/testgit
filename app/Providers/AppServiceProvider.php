<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;

use App\Http\Middleware\HMACHandler;
use GuzzleHttp\Client;
use GuzzleHttp\Handler\CurlHandler;
use GuzzleHttp\HandlerStack;
class AppServiceProvider extends ServiceProvider
{
    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
        //
    }

    /**
     * Register any application services.
     *
     * @return void
     */
    public function register()
    {
        $this->app->bind(HMACHandler::class, function () {
            return new HMACHandler(env('ANS_KEY'),env('ANS_SECRET'));
        });
        $this->app->tag([
            HMACHandler::class,
        ], 'api.client.middleware');
        $this->app->singleton('api.client', function () {
            $handler = new CurlHandler();
            $stack = HandlerStack::create($handler);
            foreach ($this->app->tagged('api.client.middleware') as $middleware) {
                $stack->push($middleware);
            }
            return new Client(['handler' => $stack,]);
        });
    }
}
