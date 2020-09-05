#!/bin/sh
cd /www
wp core is-installed
if [ $? == 1 ]; then
	echo "wp core is-installed has exit status of 1"
    wp core download
    wp core install --url=wordpress/ --path=/www --title="Wordpress" --admin_user="admin" --admin_password="pass" --admin_email=admin@system.com --skip-email
    wp term create category Test
    wp post create --post_author=admin --post_category="Test" --post-title="Test Title" --post-content="yeet" --post_excerpt=tag --post_status=publish | awk '{gsub(/[.]/, ""); print $4}' > /tmp/postid
	wp user create "bob" "writer@example.com" --role="writer" --user_pass="pass"
	wp user create "fran" "dude@example.com" --role="dude" --user_pass="pass"
	wp user create "bruce" "man@example.com" --role="man" --user_pass="pass"

    wp theme install winter
    wp theme install twentyten
    wp theme install twentytwenty
    wp theme activate twentytwenty
    wp plugin install woocommerce
fi
