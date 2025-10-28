<?php

namespace App\Console\Commands;

use App\Console\Commands\Ans;
use Illuminate\Filesystem\Filesystem;
use Carbon\Carbon;

class MakeRules extends Ans
{
    /**
     * The name and signature of the console command.
     * @author tannq@ans-asia.com
     * @var string
     */
    protected $signature = 'ans:rules {name} {--namespace=App\Rules} {--auth=mail@ans-asia.com} {--alias=App\Rules}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Use: php artisan ans:rules rules_name --auth=auth@mail.com';

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function handle()
    {
        $arguments = $this->arguments();
        $name = ucwords($arguments['name']);
        
        $namespace = $this->option('namespace');
        $alias = $this->option('alias');
        $auth = $this->option('auth');

        $name =  ucwords($name);
        $name =  str_replace(['Validate','validate'], ['',''], $name);
        $namespace =  ucwords($namespace);
        $alias =  ucwords($alias);

        $this->createDirectoryIfNotExists("{$alias}",$permissions=null);

        $rules = base_path("{$alias}/Validate{$name}.php");
        $rulesTemplate = $this->getTemplate(
            "rules",
            ["{{NAME}}","{{NAMESPACE}}","{{NOW}}","{{AUTH}}"],
            ["Validate{$name}","{$namespace}","{$this->date}",$auth]
        );
        $this->createFile($rules,$rulesTemplate,false);
    }
}
