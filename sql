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
    `project_results`.`billing_month`,
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
    AND `project_results`.`billing_month` = '202206'
    AND `users`.`company_name` LIKE '%tran%'
    AND (`bills`.`type` IN ('subscription_fee', 'point_purchase') OR `project_results`.`billing_amount` IS NOT NULL)
GROUP BY
    `projects`.`group_id`,
    `project_results`.`billing_month`;




    $paginator->getCollection()->transform(function ($item) {
            dd($item->id);
            $item->billing_amount = $item->bills->sum('money_amount');
            return $item;
        });

        public function bills()
        {
            return $this->hasMany(Bill::class, 'project_id', 'id');
        }

        public function billAmountPurchase()
        {
            return $this->bills()
                ->whereIn('type', ['point_purchase'])
                ->sum('money_amount');
        }



--------------------

        $point = $group->point()
            ->with(['pointHistory' => function (Builder $query) {
                $query->where('type', 'plus');
            }])
            ->where('group_id', $group->id)
            ->first();

        if ($point) {
            $pointInformation = $point->getPointInformation();
        } else {
            $pointInformation = [];
        }

        return Inertia::render('Plans/Index')->with([
            'points' => $pointInformation,
        ]);


class Point extends Model
{
    use HasFactory;

    public function pointHistory()
    {
        return $this->hasMany(PointHistory::class);
    }

    public function getPointInformation()
    {
        $pointInformation[] = $this->getPointInfoArray();

        foreach ($this->pointHistory as $pointHistory) {
            $pointInformation[] = $pointHistory->getPointInfoArray();
        }

        return $pointInformation;
    }

    protected function getPointInfoArray()
    {
        return [
            'start_date' =>$this->created_at ? Carbon::parse($this->created_at)->format('Y/m/d') : '' ,
            'point_purchase' => $this->point,
            'amount_purchase' => $this->price,
            'usage_points' => '',
            'period_date' =>$this->expired_at ? Carbon::parse($this->expired_at)->format('Y/m/d') : '' ,
            'remaining_points' => $this->point_remaining_amount,
        ];
    }

}

class PointHistory extends Model
{
    use HasFactory;

    public function getPointInfoArray()
    {
        return [
            'start_date' =>$this->created_at ? Carbon::parse($this->created_at)->format('Y/m/d') : '' ,
            'point_purchase' => '',
            'amount_purchase' => '',
            'usage_points' => $this->point ?? '',
            'period_date' => '',
            'remaining_points' => $this->point_remaining_amount ?? '',
        ];
    }
}
