<?php

// Note:
// This script is overkill for what it's doing.
// This is the byproduct of testing stuff for another script.

// Include packges managed by the composer autoloader.
require __DIR__ . '/vendor/autoload.php';

// Import Client class from Panther namespace.
use Symfony\Component\Panther\Client;
use Symfony\Component\DomCrawler\Crawler;

try
{
	// Start Client for Firefox in headless mode via geckodriver.
	$client = Client::createFirefoxClient();

	// Make a request to the hotel page and return an instance of crawler class.
	$url = "https://oldschool.runescape.com/";
	echo "Sending HTTP GET request: " . $url . PHP_EOL;
	$crawler = $client->request('GET', $url);

	// prints the number of runescape players.
	// text() will print the 1st inner text it finds.
	echo $crawler->filterXPath('//main/p')->text() . PHP_EOL;
}
catch (Exception $ex)
{
	echo "Error: " . $ex . PHP_EOL;
}
finally
{
	echo "Closing client" . PHP_EOL;
	$client->quit();
}

?>
