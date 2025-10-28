<?php

namespace App\Console;

use Illuminate\Console\Scheduling\Schedule;
use Illuminate\Foundation\Console\Kernel as ConsoleKernel;

class Kernel extends ConsoleKernel
{
    /**
     * The Artisan commands provided by your application.
     *
     * @var array
     */
    protected $commands = [
        Commands\MakeModule::class,
        Commands\ModuleGenerate::class,
        Commands\MakeController::class,
        Commands\MakeRequest::class,
        Commands\MakeHelper::class,
        Commands\Ans::class,
        Commands\MakeRules::class,
        Commands\cronjobMail::class,
        Commands\cronjobAPI::class,
        Commands\cronjobPasswordNotification::class,
        Commands\cronjobEvaluationNotification::class,
        Commands\cronjobKOT::class,
    ];

    /**
     * Define the application's command schedule.
     *
     * @param  \Illuminate\Console\Scheduling\Schedule  $schedule
     * @return void
     */
    protected function schedule(Schedule $schedule)
    {

        // $schedule->command('inspire')
        //          ->hourly();
        $schedule->command('cronjob:mail')->everyMinute();
        $schedule->command('cronjob:api')->everyMinute();
    }

    /**
     * Register the Closure based commands for the application.
     *
     * @return void
     */
    protected function commands()
    {
        require base_path('routes/console.php');
    }
}
