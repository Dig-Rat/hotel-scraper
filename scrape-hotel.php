<?php

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
	$url = "https://www.hyatt.com/shop/rooms/chiro?location=Hyatt%20Regency%20O%27Hare%20Chicago&checkinDate=2026-05-01&checkoutDate=2026-05-05&rooms=1&adults=1&kids=0&corp_id=G-UJYV";

	$url = "https://www.hyatt.com/shop/service/rooms/roomrates/chiro?spiritCode=chiro&rooms=1&adults=1&location=Hyatt%20Regency%20O%27Hare%20Chicago&checkinDate=2026-05-01&checkoutDate=2026-05-05&kids=0&corp_id=G-UJYV";

	$urlBase = "https://www.hyatt.com/shop/rooms/chiro";
	$urlQuery = "";
	$urlQuery = $urlQuery . "?location=Hyatt%20Regency%20O%27Hare%20Chicago";
	$urlQuery = $urlQuery . "&checkinDate=2026-05-01";
	$urlQuery = $urlQuery . "&checkoutDate=2026-05-05";
	$urlQuery = $urlQuery . "&rooms=1";
	$urlQuery = $urlQuery . "&adults=1";
	$urlQuery = $urlQuery . "&kids=0";
	$urlQuery = $urlQuery . "&corp_id=G-UJYV";
	$urlFull = $urlBase . $urlQuery;
	echo "Sending HTTP GET request" . PHP_EOL;
	$crawler = $client->request('GET', $urlFull);
	echo "Request done" . PHP_EOL;

	// Wait for body to exist so we know JS is running.
	$crawler = $client->waitFor("body", 10);

	// initial load screenshot.
	$client->takeScreenshot(__DIR__ . "/screenshot-init.png");

	// Dump the html for debugging.
	$htmlText = $crawler->html();
	DumpHtml($htmlText);

	// Print the first element after body.
	//echo "node name: " . $crawler->filterXPath('//body/*')->nodeName() . PHP_EOL;

	#$text = $crawler->filterXPath('//body/p')->innerText();
	#echo "xpathfilter: " . $text . PHP_EOL;
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

function Screenshot($client)
{

	echo "Taking screenshot" . PHP_EOL;
	$client->takeScreenshot('/images/screenshot.png');
}

function DumpHtml($htmlText)
{
	try
	{
		echo "Dumping html to file" . PHP_EOL;
		$htmlFile = fopen("exports/html-dump.html", "w");
		fwrite($htmlFile, $htmlText);
	}
	catch (Exception $ex)
	{
		echo "Error writing file: " . $ex . PHP_EOL;
	}
	finally
	{
		fclose($htmlFile);
	}

}

function DumpDom($crawler)
{
	echo "Dumping DOM: " . PHP_EOL;
	$html = '';
	foreach  ($crawler as $domElement)
	{
		var_dump($domElement);
		$html .= $domElement->ownerDocument->html($domElement);
	}
}

?>
