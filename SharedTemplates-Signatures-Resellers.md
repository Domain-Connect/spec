# Shared Templates, Signatures, and Resellers

Version: 1.0
Date: 12/16/19

Several Service Providers have large channels of partners reselling their product(s). These resellers often would benefit from Domain Connect. However, on-boarding each reseller onto the protocol isn't practical. Both from a template and bandwidth perspective.

This document will propose a solution that gives the benefits of Domain Connect to resellers without a burdensome implementation.

## Shared Templates

Synchronous templates have an attribute labeled “shared.” This flag impacts how the name of the Service Provider is rendered at the DNS Provider when the user is confirming the operation.

Normally the name of the Service Provider is retrieved from the template from the providerName attribute. If and only if this flag is set this name can be “overridden” by passing in a value on the querystring as providerName=[value].

This flag is particularly interesting for any Service Provider that has a large reseller channel.

Consider a service that is resold through a large partner network. Each of the partners sells the product through an API with the service; but owns the UX and all on-boarding of the product.  This is exactly what gsuite and O365 do.

Today these resellers typically tell customers how to configure DNS; and as such each would benefit from Domain Connect. But it isn’t practical for each of these resellers to define their own template. On-boarding these templates wouldn’t scale, and the Service Provider would likely want to control the definition of their own service template.

By defining a template and setting the shared flag, the Service Provider can own their template but allow the reseller to pass in their own name when applying the template.

As an example, consider an example where Verizon is reselling gsuite.  Rather than tell the user to manually make the necessary DNS changes, Verizon could use Domain Connect. Verizon would generate the properly formatted link to apply the gsuite template, in this case one owned by gsuite with the shared attribute set to true.  Verizon could pass the providerName on the querystring as providerName=Verizon, allowing the confirmation message to render “Do you want to allow Verizon to change DNS for the domain xyz.com to work with gsuite?”

On the surface this is simple. A reseller simply links to apply the proper template, overriding the providerName in the querystring. However, there is an additional consideration. Some templates require the generation of a signature.

## Signatures

Digital signatures exist on templates to prevent certain forms of phising attacks.

To understand the attack, one first needs to understand templates.

Templates are a simple JSON data structure. At the root are a number of attributes defining ownership and behavior of the template. But at the core is a list of “records” in the JSON indicating the values to write to DNS. These records can be static, or can contain variable portions.

For example, consider two different Service Providers and corresponding templates to enable a web-hosting service. Both services need an A Record to point to a server.

The first service may have a known IP address for all sites. As such, the value of the IP address can be placed directly in the template. But the second service might have a different IP address for different users. This service template would contain a variable for the value of the A record. The value for this at run-time would be passed on the querystring.

For this second Service Provider, a malicious user could phish users with an email asking them to click a link and re-configure their service, but place a malicious IP address on the query string. The end-user could note the URL in the email as being in the DNS Provider’s domain to the point of trusting it. Clicking on the link would ask the user to confirm the change. But if the change is applied, the A record would now point to the hacker’s service.

To prevent this type of attack the Service Provider can specify that their Domain Connect url requires a digital signature. The Service Provider would use their private key to generate the signature, and the DNS Provider would verify a valid signature.

To verify the signature the DNS Provider would require the corresponding public key. The public key is stored in DNS, typically in the Service Provider’s zone.  The location of this public key is specified partially in the template in the field syncPubKeyDomain (the root), and partially in the key= value on the querystring (the prefix).

For example, if the syncPubKeyDomain in the template was xyz.com and the value on the querystring contained key=dckey, the public key would be found in DNS at dckey.xyz.com.

By signing the Domain Connect URL, it prevents the hacker from sending malicious links.

## Shared and Signatures

When a template is for a service that has a large reseller channel where a shared template is ideal, but the template requires signatures for security purposes, how can the reseller generate the valid signature? On the surface, to do this the reseller would need the private key.

The Service Provider could provide the private key to the resellers, but this isn’t a good practice. If all resellers share the private key, it can easily become compromised.

The Service Provider could alternatively give each reseller a unique private key and a prefix code. The reseller could sign their request, including their prefix (key=) on the query string. The Service Provider would publish each public key in their zone (reseller1.xyz.com, reseller2.xyz.com, etc). This would likely work, but might become unwieldy and difficult to manage.

An alternative solution is proposed as a best practice.

Typically any service with a reseller channel would have an API for their channel partners. Each of these partners would call this API to create/provision instances of the service. And presumably this API would be an authenticated call.

The Service Provider could extend this API. At its base form this API could validate the caller (the channel partner), sign the query string, and return the proper signature for the reseller to include in their URL. But if an API is exposed, much more could be done in this call.

This API could run much of the domain connect logic. It could take the domain and host names, do DNS Provider Discovery, form the complete URL, sign it, and return this to the channel partner. If it also returned the name of the DNS Provider and any other parameters (e.g. width/height) necessary to generate the UX to the user, the reseller would simply call this API and present the links to the user.

For example, say we have a service called “hosting” provided by xyz.com.  The reseller wants to configure the domain example.com with the host (sub-domain) of foo to work with the service.  The Service Provider of xyz.com/hosting could expose an interface in the form of a GET at:

    /domainconnect?domain=example.com&host=foo

If the domain example.com did not support Domain Connect, it would return a 404.  If the domain example.com did support Domain Connect, the API would return JSON of the form:

    {
	‘providerName’: ‘GoDaddy’,
	‘width’: 750,
	‘height’: 750,
	‘url’: ‘https://dcc.godaddy.com/manage/v2/domainTemplates/providers/xyz.com/services/hosting/apply?domain=example.com&host=sub&sig=tzB9xXCRut4a8KPa0JMzPkv6izIq8Ca3wr0%2BzIedet2NRrYoT6NXBv1Bpghxjf03q3jPv1xOcyN0oRt6L%2B2wKxjTn3%2FlbCA%2B%2FjZSnIFJQWyb7mEwsOeIru5oFq6kitxiT6ILjDkSsACPpopCwzQSNMxqc34ym85q1GfoYyhgXUefwJh0JXBFbU7b4j6H72Op7FKZyO%2BLML81MEH7VgvuclWAhelzAseO5lloqA7t6G6wiCeehQpYvEmtC0L88v0hqgWifpyAjcg3XBQyLWGlqFh9TEZmiA3qSTWeXonO%2FdIlKUZd3gW1S%2FC79M6WG0DF6gk5Usa%2F%2F3CZX5DpIUOHHg%3D%3D&key=_dck1’
    }

Now the reseller simply calls this API. If a value is returned, the link is presented to the user. If a 404 is returned the reseller would give the user instructions (which is par for the course today).
