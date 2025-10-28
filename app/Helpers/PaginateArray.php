<?php
namespace App\Helpers;
/**
 *  @author tannq@ans-asia.com
 *  use with php version require 5.5.* ++
 *	 require fontawesome if use render paginate button
 **/

class PaginateArray
{
    /**
     * Properties array
     * @var array
     * @access private
     */
    public $total = 0;

    /**
     * Properties array
     * @var array
     * @access private
     */
    private $_properties = [];

    /**
     * Default configurations
     * @var array
     * @access public
     */
    public $_defaults = [
        'page' => 1,
        'perPage' => 10
    ];

    /**
     * Constructor
     *
     * @param array $array   Array of results to be paginated
     * @param int   $curPage The current page interger that should used
     * @param int   $perPage The amount of items that should be show per page
     * @return void
     * @access public
     */
    public function __construct($array, $curPage = null, $perPage = null)
    {
        $this->array   = $array;
        $this->curPage = ($curPage == null ? $this->defaults['page']    : $curPage);
        $this->perPage = ($perPage == null ? $this->defaults['perPage'] : $perPage);
        $this->total = count($array);
        $this->pages = ceil($this->total / $this->perPage);
    }

    /**
     * Global setter
     *
     * Utilises the properties array
     *
     * @param string $name  The name of the property to set
     * @param string $value The value that the property is assigned
     * @return void
     * @access public
     */
    public function __set($name, $value)
    {
        $this->_properties[$name] = $value;
    }

    /**
     * Global getter
     *
     * Takes a param from the properties array if it exists
     *
     * @param string $name The name of the property to get
     * @return mixed Either the property from the internal
     * properties array or false if isn't set
     * @access public
     */
    public function __get($name)
    {
        if (array_key_exists($name, $this->_properties)) {
            return $this->_properties[$name];
        }
        return false;
    }

    /**
     * Set the show first and last configuration
     *
     * This will enable the "<< first" and "last >>" style
     * links
     *
     * @param boolean $showFirstAndLast True to show, false to hide.
     * @return void
     * @access public
     */
    public function setShowFirstAndLast($showFirstAndLast)
    {
        $this->_showFirstAndLast = $showFirstAndLast;
    }

    /**
     * Set the main seperator character
     *
     * By default this will implode an empty string
     *
     * @param string $mainSeperator The seperator between the page numbers
     * @return void
     * @access public
     */
    public function setMainSeperator($mainSeperator)
    {
        $this->mainSeperator = $mainSeperator;
    }

    /**
     * Get the result portion from the provided array
     *
     * @return array Reduced array with correct calculated offset
     * @access public
     */
    public function get()
    {
        // Assign the page variable
        if (empty($this->curPage) !== false) {
            $this->page = $this->curPage; // using the get method
        } else {
            $this->page = 1; // if we don't have a page number then assume we are on the first page
        }

        // Take the length of the array
        $this->length = count($this->array);

        // Get the number of pages
        $this->pages = ceil($this->length / $this->perPage);

        // Calculate the starting point
        $this->start = ceil(($this->page - 1) * $this->perPage);

        // return the portion of results
        return array_slice($this->array, $this->start, $this->perPage);
    }

    /**
     * Get the html links for the generated page offset
     *
     * @param array $params A list of parameters (probably get/post) to
     * pass around with each request
     * @return mixed  Return description (if any) ...
     * @access public
     */
    public function render($params = array())
    {
        $page      = $this->page;
        $total_pages = $this->pages;

        // Concatenate the get variables to add to the page numbering string
        $queryUrl = '';
        if (!empty($params) === true) {
            unset($params['page']);
            if(!empty($params)===true) {
                $queryUrl = '&amp;' . http_build_query($params);
            }
        }
        list($min,$max) = $this->getPageRange($page, $total_pages);

        $render = '<ul class="pagination pagination-sm">';
        $disabled = $page==1 ? 'disabled' : '';
        $tabindex = $page==1 ? 'tabindex="-1"' : '';
        $prevPage = ($page > 1) ? ($page - 1) : $page;

        // show first page
        $render .= ' <li class="'.$disabled.'"><a '.$tabindex.' href="?page=1' . $queryUrl . '"><i class="fa fa-angle-double-left"></i></a></li>  ';

        // show prev page
        $render .= ' <li class="'.$disabled.'"><a '.$tabindex.' href="?page=' . $prevPage . $queryUrl . '"><i class="fa fa-angle-left"></i></a> </li> ';
        foreach (range($min, $max) as $number)
        {
            $active = $page==$number ? 'active' : '';
            $render .= "<li class='{$active}'><a href=\"?page=".$number."\" >". $number. "</a></li>";
        }
        $disabled = $page == $total_pages ? 'disabled' : '';
        $tabindex = $page == $total_pages ? 'tabindex="-1"' : '';
        $nextPage = $page < $total_pages ? ($page + 1) : $page;

        // show nexpage
        $render .= ' <li class="'.$disabled.'"><a '.$tabindex.' href="?page=' . $nextPage . $queryUrl . '"><i class="fa fa-angle-right"></i></a></li> ';

        // show last page
        $render .= '<li class="'.$disabled.'"> <a '.$tabindex.' href="?page=' . ($total_pages) . $queryUrl . '"> <i class="fa fa-angle-double-right"></i> </a></li> ';

        $render .= '</ul>';

        return $render;
    }

    /**
     * Get the html links for the generated page offset
     *
     * @param array $params A list of parameters (probably get/post) to
     * pass around with each request
     * @return mixed  Return description (if any) ...
     * @access public
     */
    public function getPageRange($current, $max, $only_show = 10)
    {
        $only_show = $max < $only_show ? $max : $only_show;
        $middle = ceil($only_show/2);
        if ($current <= $middle){
            return [1, $only_show];
        }
        if ($current > $middle && $current <= ($max - $middle)) {
            return [
                $current - $middle > 0 ? $current - $middle : 1,
                $current + $middle
            ];
        }

        if ($current <= $max && ($max - $current) > $middle) {

            return [
                $current - ($only_show - 1) > 0 ? $current - ($only_show - 1) : 1,
                $max
            ];
        }
        if(($max - $current) <= $middle )
        {
            return [
                $current - ($only_show - ($max - $current)) > 0 ? $current - ($only_show - ($max - $current)) : 1,
                $max
            ];
        }

    }

    public function getParamPaginate()
    {
        $this->total = count($this->array);
        return $this;
    }
}