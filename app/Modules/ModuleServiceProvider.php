<?php 
namespace App\Modules;
use File;
use Cache;
use Illuminate\Support\Facades\Route;
use Dao;
class ModuleServiceProvider extends  \Illuminate\Support\ServiceProvider
{
	/**
	* Bootstrap any application services.
	* @author tannq@ans-asia.com 
	* @created at 2017-07-27 04:32:56
	* @return void
	*/
	public function boot()
	{
		define('AUTHORITY_KEY',md5(env('APP_NAME', 'MIRAI')));
		define('CUSTOMER_KEY',md5('MIRAI_CUSTOMER'));

		$this->app->singleton('messages', function($app)
        {
           return new \App\L0020();
        });
		
		$this->modules();
	}

	/**
	* Register any application services.
	* @author tannq@ans-asia.com 
	* @created at 2017-07-27 04:32:56
	* @return void
	*/
	public function register(){


	}

	 /**
	 * make module
	 * @author tannq@ans-asia.com 
	 * @created at 2017-07-27 04:32:56
	 * @return void
	 */
 	private function modules()
 	{
		$listModule = array_map('basename', File::directories(__DIR__));
		foreach ($listModule as $module) 
		{
			$namespace = "App\\Modules\\".$module."\Controllers";
		 	if(file_exists(__DIR__.'/'.$module.'/routes.php')) {
		 		$this->mapWebRoutes($namespace,__DIR__.'/'.$module.'/routes.php');
			}
			if(is_dir(__DIR__.'/'.$module.'/Views')) {
				$this->loadViewsFrom(__DIR__.'/'.$module.'/Views', $module);
		 	}
		}
 	}

    /**
     * get guard.
     *
     * @return void
     */
    protected function guard($guard)
    {
        return \Auth::guard($guard);
    } 

    /**
     * Define the "web" routes for the application.
     *
     * These routes all receive session state, CSRF protection, etc.
     *
     * @return void
     */
    protected function mapWebRoutes($namespace,$path_to_file)
    {
        Route::middleware('web')
             ->namespace($namespace)
             ->group($path_to_file);
    }

}