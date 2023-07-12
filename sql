public function __invoke(Request $request): \Inertia\Response
{
    $companyName = $request->query('company_name');
    $billingMonth = $request->query('billing_month');

    $paginator = Project::with(['group', 'group.billingUser'])
        ->select(['group_id', 'billing_month'])
        ->selectRaw('SUM(
            CASE
                WHEN project_results.billing_amount IS NOT NULL THEN project_results.billing_amount
                ELSE bills.money_amount
            END
        ) AS billing_amount')
        ->join('groups', 'groups.id', '=', 'projects.group_id')
        ->join('users', 'users.id', '=', 'groups.billing_user_id')
        ->leftJoin('project_results', function ($join) {
            $join->on('project_results.project_id', '=', 'projects.id')
                ->whereNull('project_results.deleted_at');
        })
        ->leftJoin('bills', function ($join) {
            $join->on('bills.project_id', '=', 'projects.id')
                ->whereIn('bills.type', ['subscription_fee', 'point_purchase'])
                ->whereNull('bills.deleted_at');
        })
        ->when($companyName !== null, function ($query) use ($companyName) {
            $query->where('users.company_name', 'like', '%' . $companyName . '%');
        })
        ->when($billingMonth !== null, function ($query) use ($billingMonth) {
            $query->where('billing_month', $billingMonth);
        })
        ->whereNull('projects.deleted_at')
        ->groupBy('group_id', 'billing_month')
        ->orderByDesc('billing_month')
        ->orderBy('group_id')
        ->paginate(20);

    return Inertia::render('YourView', [
        'paginator' => $paginator,
    ]);
}


SELECT
    `projects`.`group_id`,
    `projects`.`billing_month`,
    SUM(
        CASE
            WHEN `project_results`.`billing_amount` IS NOT NULL THEN `project_results`.`billing_amount`
            ELSE `bills`.`money_amount`
        END
    ) AS billing_amount
FROM
    `projects`
INNER JOIN `groups` ON `groups`.`id` = `projects`.`group_id`
INNER JOIN `users` ON `users`.`id` = `groups`.`billing_user_id`
LEFT JOIN `project_results` ON `project_results`.`project_id` = `projects`.`id`
LEFT JOIN `bills` ON `bills`.`project_id` = `projects`.`id`
WHERE
    `projects`.`deleted_at` IS NULL
    AND `projects`.`billing_month` = '202206'
    AND `users`.`company_name` LIKE '%tran%'
    AND (`bills`.`type` IN ('subscription_fee', 'point_purchase') OR `project_results`.`billing_amount` IS NOT NULL)
GROUP BY
    `projects`.`group_id`,
    `projects`.`billing_month`;
